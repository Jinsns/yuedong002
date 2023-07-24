//
//  GiraffeScene.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/23.
//

import Foundation
import SceneKit
import CoreMotion

class GiraffeScene: SCNScene, SCNPhysicsContactDelegate, ObservableObject {
    
    private let motionManager = CMMotionManager()
    
    private var planetNode: SCNNode?
    private var neckNode: SCNNode?
    private var leafNode: SCNNode?
    
    @Published var score: Int = 0
    var shouldAddLeafNode = false
    
    var leafXPosition = Float(0.0)
    var leafYPosition = Float(2.0)
    var leafZPosition = Float(0.0)
    
    
    
    override init() {
        super.init()
        
        physicsWorld.contactDelegate = self   //both this line and next line OK, also can set delegate in View onAppear
//        self.physicsWorld.contactDelegate = self
        
//        self.physicsWorld.speed = 1.0
        
        self.score = 0
        addBackground()
//        addPlanetNode()
        addNeckNode() // 添加脖子节点
        addLeafNode(xPosition: leafXPosition, yPosition: leafYPosition, zPosition: leafZPosition)  //添加叶子结点
        configureCamera()
        addOmniLight()
        
        //control rotation
        addPlanetRotation()
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCamera() {
        self.rootNode.position = SCNVector3(x: 0.0, y: 0, z: -8)
    }
    
    func addBackground() {
//        background.contents = UIColor.black
        if let backgroundImage = UIImage(named: "Ellipse") {
            // Create an SCNMaterial with the image as its contents
            let backgroundMaterial = SCNMaterial()
            backgroundMaterial.diffuse.contents = backgroundImage
            
            // Set the material as the background of the scene
            self.background.contents = backgroundMaterial
        }
    }
    
    func addNeckNode() {
        guard let scene = SCNScene(named: "neck.dae") else {
            print("Failed to load 'neck.dae'")
            return
        }

        guard let neckNode = scene.rootNode.childNodes.first else {
            print("Failed to find the first child node in 'neck.dae'")
            return
        }
        
        // 根据需要对脖子模型进行缩放和位置调整
        neckNode.scale = SCNVector3(0.2, 0.2, 1.0)
        neckNode.position = SCNVector3(0, 0, 0) // 设置位置，根据需要调整
        
        let neckBoundingBox = neckNode.boundingBox
        let neckSize = SCNVector3(neckBoundingBox.max.x - neckBoundingBox.min.x,
                                  neckBoundingBox.max.y - neckBoundingBox.min.y,
                                  neckBoundingBox.max.z - neckBoundingBox.min.z)
//        neckNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: SCNBox(width: CGFloat(neckSize.x), height: CGFloat(neckSize.y), length: CGFloat(neckSize.z), chamferRadius: 0.0), options: nil))
        
        neckNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        neckNode.physicsBody?.categoryBitMask = 1 // Set a unique bitmask for the "neck" node
        neckNode.physicsBody?.contactTestBitMask = 2 // Set the bitmask of nodes to be notified about contact
        neckNode.name = "neck"
        

        self.rootNode.addChildNode(neckNode)
        self.neckNode = neckNode
    
    }
    
    func addPlanetNode() {
        let planetMaterial = SCNMaterial()
        planetMaterial.diffuse.contents = UIImage(named: "Ellipse")
           
        let planetGeometry = SCNSphere(radius: 1)
        planetGeometry.materials = [planetMaterial]

        let planetNode = SCNNode(geometry: planetGeometry)
        planetNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        planetNode.physicsBody?.categoryBitMask = 3 // Set a unique bitmask for the "planet" node
        planetNode.physicsBody?.contactTestBitMask = 1 | 2 // Set the bitmask of nodes to be
        planetNode.position = SCNVector3(0, 0, 0)
        self.rootNode.addChildNode(planetNode)
        self.planetNode = planetNode
    }
    
    func addLeafNode(xPosition: Float, yPosition: Float, zPosition: Float) {
        let leafMaterial = SCNMaterial()
        leafMaterial.diffuse.contents = UIImage(named: "leaf")
        // Add "leaf" node to simulate its appearance position
//        let leafGeometry = SCNSphere(radius: 1)
        let leafGeometry = SCNBox(width: 2, height: 1, length:1, chamferRadius: 0.2)
        
        leafGeometry.materials = [leafMaterial]
        
        let leafNode = SCNNode(geometry: leafGeometry)
        leafNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        leafNode.physicsBody?.categoryBitMask = 2 // Set a unique bitmask for the "leaf" node
        leafNode.physicsBody?.contactTestBitMask = 1  // Set the bitmask of nodes to be notified about contact
        
        leafNode.position = SCNVector3(x: xPosition, y: yPosition, z: zPosition)
        leafNode.name = "leaf"
        self.rootNode.addChildNode(leafNode)
        self.leafNode = leafNode
        
        
        print("leafNode position: ", leafNode.position)
        
//        let leafNode = SCNNode(geometry: SCNBox(width: 100, height: 50, length:100)
//        leafNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green // Set the color to clear to make it invisible
//        leafNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//        leafNode.position = SCNVector3(5, 5, 2) // Set the position of the "leaf" node
//
//        self.leafNode = leafNode
    }

    
    func addOmniLight() {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        
        omniLightNode.light?.type = SCNLight.LightType.omni
        omniLightNode.light?.color = UIColor(white: 1, alpha: 1)
        omniLightNode.position = SCNVector3Make(50, 0, 30)
        
        self.rootNode.addChildNode(omniLightNode)
    }

    
    
    func addPlanetRotation() {
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] deviceMotion, error in
            guard let attitude = deviceMotion?.attitude else { return }
                        
            self?.planetNode?.eulerAngles = SCNVector3(
                x: Float(attitude.pitch),
                y: Float(attitude.roll),
                z: Float(attitude.yaw)
            )
            
            self?.neckNode?.eulerAngles = SCNVector3(
                x: Float(attitude.pitch) * 3,
                y: Float(attitude.roll) * 3,
                z: Float(attitude.yaw) * 3
            )
        }
    }
    
    
    // SCNPhysicsContactDelegate method to handle contact between physics bodies
//    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
//        print("nodeA: ", contact.nodeA.name, contact.nodeA.categoryBitMask)
//        print("nodeB: ", contact.nodeB.name, contact.nodeB.categoryBitMask)
//
//        // Check if "neck" and "leaf" nodes have collided
//        if (contact.nodeA.name == "neck" && contact.nodeB.name == "leaf") ||
//           (contact.nodeA.name == "leaf" && contact.nodeB.name == "neck") {
//            // Add one point to the score when "neck" and "leaf" collide
//            self.score += 1
//            print("score: \(self.score)" )
//
//            // Update the score label or perform any other actions as needed
//            // scoreLabel.text = "Score: \(score)"
//        }
//
//    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        
        print("nodeA: ", contact.nodeA.name, contact.nodeA.categoryBitMask)
        print("nodeB: ", contact.nodeB.name, contact.nodeB.categoryBitMask)
        print("contact begin")
        print("shouldAddLeafNode: ", shouldAddLeafNode)
        
        
        
        if (contact.nodeA.name == "neck" && contact.nodeB.name == "leaf") {
            print("contact 1")
            // Add one point to the score when "neck" and "leaf" collide
            self.score += 1
            print("score: \(self.score)" )
            
            contact.nodeB.removeFromParentNode()  //remove leafnode
            
            self.shouldAddLeafNode = true
            self.leafYPosition = -self.leafYPosition
            self.addLeafNode(xPosition: self.leafXPosition, yPosition: self.leafYPosition, zPosition: self.leafZPosition)
            
        } else if (contact.nodeA.name == "leaf" && contact.nodeB.name == "neck") {
            print("contact 2")
            self.score += 1
            print("score: \(self.score)")
            
            contact.nodeA.removeFromParentNode()  //remove leafnode
            
            self.shouldAddLeafNode = true
            self.leafYPosition = -self.leafYPosition
            self.addLeafNode(xPosition: self.leafXPosition, yPosition: self.leafYPosition, zPosition: self.leafZPosition)
            
        }
        
//        if shouldAddLeafNode {
//            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
//                print("after 3 seconds1")
//                self.addLeafNode() // Add the "leaf" node back to the scene
//                self.shouldAddLeafNode = false
//    //            self.configureCamera()
//            }
//        }
        
        
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
//        print("contact update")
        
        
        
        // Check if "neck" and "leaf" nodes have collided
        
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        print("contact end")
    }
    
    func getCurrentScore() -> Int {
        return self.score
    }
    
    
    
}
