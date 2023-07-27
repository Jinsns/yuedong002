//
//  GiraffeScene.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/23.
//

import Foundation
import SceneKit
import CoreMotion
import AVFoundation

class GiraffeScene: SCNScene, SCNPhysicsContactDelegate, ObservableObject, AVAudioMixing {
    
    //conform to AVAudioMixing protocol
    func destination(forMixer mixer: AVAudioNode, bus: AVAudioNodeBus) -> AVAudioMixingDestination? {
        return nil
    }
    
    var volume: Float = 0.0
    var pan: Float = 0.0

    var renderingAlgorithm: AVAudio3DMixingRenderingAlgorithm = AVAudio3DMixingRenderingAlgorithm.sphericalHead
  
    var sourceMode: AVAudio3DMixingSourceMode = .bypass
    var pointSourceInHeadMode: AVAudio3DMixingPointSourceInHeadMode = .bypass
    
    var rate: Float = 1.2
    var reverbBlend: Float = 40.0
    var obstruction: Float = -100.0
    var occlusion: Float = -100.0
    
    var position = AVAudio3DPoint(x: 0, y: 0, z: 0)
    //end protocal AVAudioMixing
    
    
    private let motionManager = CMMotionManager()
    
//    private var planetNode: SCNNode?
    private var neckNode: SCNNode?
    private var leafNode: SCNNode?
    
    @Published var score: Int = 0
    
    var leafXPosition = Float(1.0)
    var leafYPosition = Float(0.0)
    var leafZPosition = Float(0.0)
    
    //neckNode.eulerAngles = SCNVector3(0, -3.14 / 2 + 3.14 / 10, 0) // 设置旋转角度，根据需要调整
    let neckInitialXEulerAngle = Float(0.0)
    let neckInitialYEulerAngle = Float(-3.14 / 2 - 3.14 / 16)
    let neckInitialZEulerAngle = Float(0.0)
    
    
    
    override init() {
        super.init()
//        setupAudioEngine()
        
        
        physicsWorld.contactDelegate = self   //both this line and next line OK, also can set delegate in View onAppear
//        self.physicsWorld.contactDelegate = self
        
//        self.physicsWorld.speed = 1.0
        
        self.score = 0
        addBackground()
//        addPlanetNode()
        addNeckNode(neckInitialXEulerAngle: neckInitialXEulerAngle, neckInitialYEulerAngle: neckInitialYEulerAngle, neckInitialZEulerAngle: neckInitialZEulerAngle) // 添加脖子节点
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
        self.rootNode.position = SCNVector3(x: 0.0, y: -1, z: -8)
    }
    
    func addBackground() {
        //add an color or image as the background
//        background.contents = UIColor.black
//        background.contents = UIColor.gray
        
        
//        if let backgroundImage = UIImage(named: "gameBackgroundLayer") {
//            print("gameBackground available.")
//            self.background.contents = "gameBackgroundLayer"  //just give the name of image in assets
//        } else {
//            print("gameBackground unavailable")
//        }
        
        //add a SCNPlane as the background
        let backgroundMaterial = SCNMaterial()
        backgroundMaterial.diffuse.contents = UIImage(named: "gameBackgroundSourceImage") //3000 * 2000
        let backgroundGeometry = SCNPlane(width: 60, height: 40)
        backgroundGeometry.materials = [backgroundMaterial]
        let backgroundNode = SCNNode(geometry: backgroundGeometry)
        backgroundNode.position = SCNVector3(0, 0, -10)
        self.rootNode.addChildNode(backgroundNode)
        
    }
    
    func addNeckNode(neckInitialXEulerAngle: Float, neckInitialYEulerAngle: Float, neckInitialZEulerAngle: Float) {
        guard let scene = SCNScene(named: "giraffe0.dae") else {
            print("Failed to load 'giraffe0.dae'")
            return
        }

        guard let neckNode = scene.rootNode.childNodes.first else {
            print("Failed to find the first child node in 'giraffe0.dae'")
            return
        }
        
        // 根据需要对脖子模型进行缩放和位置调整
//        neckNode.scale = SCNVector3(0.2, 0.2, 1.0)   //缩放
        neckNode.position = SCNVector3(0, -3, 0) // 设置位置，根据需要调整
        neckNode.eulerAngles = SCNVector3(neckInitialXEulerAngle, neckInitialYEulerAngle, neckInitialZEulerAngle) // 设置旋转角度，根据需要调整
        
        
//        let neckBoundingBox = neckNode.boundingBox
//        let neckSize = SCNVector3(neckBoundingBox.max.x - neckBoundingBox.min.x,
//                                  neckBoundingBox.max.y - neckBoundingBox.min.y,
//                                  neckBoundingBox.max.z - neckBoundingBox.min.z)
//        neckNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: SCNBox(width: CGFloat(neckSize.x), height: CGFloat(neckSize.y), length: CGFloat(neckSize.z), chamferRadius: 0.0), options: nil))
        
        //line below creates more accurate physics body than the line above, with more computation costs
        neckNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)  //if both neck and leaf are .static, can't collide
        neckNode.physicsBody?.categoryBitMask = 1 // Set a unique bitmask for the "neck" node
        neckNode.physicsBody?.contactTestBitMask = 2 // Set the bitmask of nodes to be notified about contact
        neckNode.name = "neck"
        
        self.rootNode.addChildNode(neckNode)
        self.neckNode = neckNode
    
    }
    
//    func addPlanetNode() {
//        let planetMaterial = SCNMaterial()
//        planetMaterial.diffuse.contents = UIImage(named: "Ellipse")
//
//        let planetGeometry = SCNSphere(radius: 1)
//        planetGeometry.materials = [planetMaterial]
//
//        let planetNode = SCNNode(geometry: planetGeometry)
//        planetNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
//        planetNode.physicsBody?.categoryBitMask = 3 // Set a unique bitmask for the "planet" node
//        planetNode.physicsBody?.contactTestBitMask = 1 | 2 // Set the bitmask of nodes to be
//        planetNode.position = SCNVector3(0, 0, 0)
//        planetNode.name = "planet"
//
//        self.rootNode.addChildNode(planetNode)
//        self.planetNode = planetNode
//    }
    
    func addLeafNode(xPosition: Float, yPosition: Float, zPosition: Float) {
        let leafMaterial = SCNMaterial()
        leafMaterial.diffuse.contents = UIImage(named: "leaf")
        let leafGeometry = SCNPlane(width: 1.0, height: 1.0)
//        let leafGeometry = SCNBox(width: 1.0, height: 1.0, length:0.2, chamferRadius: 0.2)
        leafGeometry.materials = [leafMaterial]
        
        let leafNode = SCNNode(geometry: leafGeometry)
        leafNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        leafNode.physicsBody?.categoryBitMask = 2 // Set a unique bitmask for the "leaf" node
        leafNode.physicsBody?.contactTestBitMask = 1  // Set the bitmask of nodes to be notified about contact
        
        leafNode.position = SCNVector3(x: xPosition, y: yPosition, z: zPosition)
        leafNode.name = "leaf"
        
        let leafAudioSource = SCNAudioSource(fileNamed: "monoPianoD.mp3")!
        leafAudioSource.isPositional = true // Enable 3D spatialization
        leafAudioSource.shouldStream = false // Use streaming for longer audio files
        leafNode.addAudioPlayer(SCNAudioPlayer(source: leafAudioSource))
        //播放
        leafNode.runAction(SCNAction.playAudio(leafAudioSource, waitForCompletion: false))
        
        
        self.rootNode.addChildNode(leafNode)
        self.leafNode = leafNode
        
    }

    func addLeafNodeRandomPosition() {
        let xPosition = Float.random(in: -1.5...1.5) // Set the range of x position as needed
        let yPosition = Float.random(in: -2...2) // Set the range of y position as needed
//        let zPosition = Float.random(in: -5...5) // Set the range of z position as needed
        let zPosition = Float(0)
        
        addLeafNode(xPosition: xPosition, yPosition: yPosition, zPosition: zPosition)
    }

    
    func addOmniLight() {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        
        omniLightNode.light?.type = SCNLight.LightType.omni
        omniLightNode.light?.color = UIColor(white: 1, alpha: 1)
        omniLightNode.position = SCNVector3Make(0, 0, 30)
        
        self.rootNode.addChildNode(omniLightNode)
    }

    
    
    func addPlanetRotation() {
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] deviceMotion, error in
            guard let attitude = deviceMotion?.attitude else { return }
                        
//            self?.planetNode?.eulerAngles = SCNVector3(
//                x: Float(attitude.pitch),
//                y: Float(attitude.roll),
//                z: Float(attitude.yaw)
//            )
            
            self?.neckNode?.eulerAngles = SCNVector3(
                x: self!.neckInitialXEulerAngle + Float(attitude.pitch) * 3,
                y: self!.neckInitialYEulerAngle + Float(attitude.roll) * 3,
                z: self!.neckInitialZEulerAngle + Float(attitude.yaw) * 3
            )
        }
    }
    
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
//        self.collisionAudioPlayer.stop()
        
        print("nodeA: ", contact.nodeA.name, contact.nodeA.categoryBitMask)
        print("nodeB: ", contact.nodeB.name, contact.nodeB.categoryBitMask)
        print("contact begin")
        
        if (contact.nodeA.name == "neck" && contact.nodeB.name == "leaf") {
            print("contact 1")
            
            //collision sound effect
//            self.playCollisionAudio(at: contact.nodeB.position)
            
            // Add one point to the score when "neck" and "leaf" collide
            self.score += 1
            print("score: \(self.score)" )
            
            contact.nodeB.removeFromParentNode()  //remove leafnode
            

//            self.leafXPosition = -self.leafXPosition
//            self.leafYPosition = -self.leafYPosition
//            self.addLeafNode(xPosition: self.leafXPosition, yPosition: self.leafYPosition, zPosition: self.leafZPosition)
            addLeafNodeRandomPosition()
            self.leafNode?.opacity = 0.0 // Set the initial opacity to 0
            self.leafNode?.runAction(SCNAction.fadeIn(duration: 0.5))
            
        } else if (contact.nodeA.name == "leaf" && contact.nodeB.name == "neck") {
            print("contact 2")
//            self.playCollisionAudio(at: contact.nodeA.position)
            self.score += 1
            print("score: \(self.score)")
            
            contact.nodeA.removeFromParentNode()  //remove leafnode
            
//            self.leafXPosition = -self.leafXPosition
//            self.leafYPosition = -self.leafYPosition
//            self.addLeafNode(xPosition: self.leafXPosition, yPosition: self.leafYPosition, zPosition: self.leafZPosition)
            addLeafNodeRandomPosition()
            self.leafNode?.opacity = 0.0 // Set the initial opacity to 0
            self.leafNode?.runAction(SCNAction.fadeIn(duration: 0.5))
            
        }
        
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
//        print("contact update")
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        print("contact end")
    }
    
    
}
