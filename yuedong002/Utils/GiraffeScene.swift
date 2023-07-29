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
    private var neckJumpAnimation: CAAnimationGroup?
    
    private var neckNode1: SCNNode?   // bottom part
    private var neckNode2: SCNNode?   //above part
    
    private var KAnimationKey: String = "Animation"
    
    
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
        
//        addNeckNode1(neckInitialXEulerAngle: neckInitialXEulerAngle, neckInitialYEulerAngle: neckInitialYEulerAngle, neckInitialZEulerAngle: neckInitialZEulerAngle)
//        addNeckNode2(neckInitialXEulerAngle: neckInitialXEulerAngle, neckInitialYEulerAngle: neckInitialYEulerAngle, neckInitialZEulerAngle: neckInitialZEulerAngle)
//        addJoint()
//        spawnNodes()
        
        loadAnimations()
        
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
    
    func loadAnimations() {
        // Load the DAE file with skeletal animations
//        guard let animationsScene = SCNScene(named: "rotatingCube.dae") else {
//            print("failed to load rotatingCube.dae")
//            return
//        }
//        print("rotatingCube position1: ", animationsScene.rootNode.position)
//
//        animationsScene.rootNode.position = self.neckNode!.position
//        print("rotatingCube position2: ", animationsScene.rootNode.position)
//
//        print(animationsScene.rootNode)
//        print(animationsScene.rootNode.childNodes)
        
        //load animation group
        var animationGroups: [CAAnimation] = []
        if let url = Bundle.main.url(forResource: "rotatingCube", withExtension: "dae") {
            let sceneSource = SCNSceneSource(url: url)
            print("loaded ratatingcube.dae")
            let animationIDs = sceneSource?.identifiersOfEntries(withClass: CAAnimation.self)
            print("animationIDs: ", animationIDs)
            var maxDuration: CFTimeInterval = 0.0
            if let animations = animationIDs {
                for item in animations {
                    if let ani = sceneSource?.entryWithIdentifier(item, withClass: CAAnimation.self) {
                        maxDuration = max(maxDuration, ani.duration)
                        animationGroups.append(ani)
                    }
                }
            }
            
            let group = CAAnimationGroup()
            group.animations = animationGroups
            group.duration = maxDuration
//            group.repeatCount = MAXFLOAT
//            group.autoreverses = true
            
            //record this animation
            self.neckJumpAnimation = group
            
            //add animation
            self.rootNode.childNode(withName: "neck", recursively: true)!.addAnimation(group, forKey: self.KAnimationKey)
            
            //validate skeletonNode
            let skeletonNode = self.rootNode
            for item in skeletonNode.childNodes {
                debugPrint("skinner:\(String(describing: item.skinner))")
            }
            
        }
        
//        guard let animationsScene = SCNScene(named: "rotatingCube.dae"),
//              let animationsNode = animationsScene.rootNode.childNode(withName: "Animations", recursively: true) else {
//            print("Failed to load animationsNode")
//            return
//        }

//        // Set up the animation controller
//        let animationPlayer = animationsNode.animationPlayer(forKey: "animationName")
//        animationPlayer?.speed = 1.0 // Adjust the animation speed as needed
//        animationPlayer?.blendFactor = 1.0 // Adjust the blend factor as needed
//
//        // Add the animations node to the scene
//        self.rootNode.addChildNode(animationsNode)
    }
    
    func neckJump() {
        self.neckNode?.addAnimation(self.neckJumpAnimation!, forKey: "neckJump")
    }
    
//    func playAnimation() {
//        guard let animationsNode = self.rootNode.childNode(withName: "animationsNode", recursively: true) else {
//            print("Failed to find the animationsNode")
//            return
//        }
//
//        guard let animationPlayer = animationsNode.animationPlayer(forKey: "animationName") else {
//                print("Animation player not found")
//                return
//            }
//
//        animationPlayer.play()
//    }
    
    
    func addNeckNode1(neckInitialXEulerAngle: Float, neckInitialYEulerAngle: Float, neckInitialZEulerAngle: Float) {  //bottom part
        let neckNode1Material = SCNMaterial()
        neckNode1Material.diffuse.contents = UIColor.red
        let neckNode1Geometry = SCNBox(width: 1, height: 2, length: 1, chamferRadius: 0.0)
        neckNode1Geometry.materials = [neckNode1Material]
        let neckNode1 = SCNNode(geometry: neckNode1Geometry)
        neckNode1.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        neckNode1.physicsBody?.categoryBitMask = 11 // Set a unique bitmask for the "neck" node
        neckNode1.physicsBody?.contactTestBitMask = 21 // Set the bitmask of nodes to be notified about contact
        neckNode1.physicsBody?.mass = 5.0
        neckNode1.physicsBody?.friction = 0.5
        neckNode1.position = SCNVector3(0, 0, 0)
        neckNode1.eulerAngles = SCNVector3(x: neckInitialXEulerAngle, y: neckInitialYEulerAngle, z: neckInitialZEulerAngle)
        neckNode1.name = "neckNode1"
        self.rootNode.addChildNode(neckNode1)
        self.neckNode1 = neckNode1
    }
    
    func addNeckNode2(neckInitialXEulerAngle: Float, neckInitialYEulerAngle: Float, neckInitialZEulerAngle: Float) {  //bottom part
        let neckNode2Material = SCNMaterial()
        neckNode2Material.diffuse.contents = UIColor.yellow
        let neckNode2Geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.0)
        neckNode2Geometry.materials = [neckNode2Material]
        let neckNode2 = SCNNode(geometry: neckNode2Geometry)
        neckNode2.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        neckNode2.physicsBody?.categoryBitMask = 12 // Set a unique bitmask for the "neck" node
        neckNode2.physicsBody?.contactTestBitMask = 22 // Set the bitmask of nodes to be notified about contact
        neckNode2.physicsBody?.mass = 5.0
        neckNode2.physicsBody?.friction = 0.5
        
        neckNode2.position = SCNVector3(0, 2, 0)
        neckNode2.eulerAngles = SCNVector3(x: neckInitialXEulerAngle, y: neckInitialYEulerAngle, z: neckInitialZEulerAngle)
        neckNode2.name = "neckNode2"
        self.rootNode.addChildNode(neckNode2)
        self.neckNode2 = neckNode2
    }
    
    func addJoint() {
        let anchor = SCNPhysicsBallSocketJoint(bodyA: self.neckNode1!.physicsBody!, anchorA: SCNVector3(0, 2, 0), bodyB: self.neckNode2!.physicsBody!, anchorB: SCNVector3(0, 2, 0))
        self.physicsWorld.addBehavior(anchor)
    }
    
    func spawnNodes() {
        var headObject = Head()
        var theHead = headObject.getHead()
        var slideObject = NeckSlide()
        
        //attach to floor
        let floorObject = Floor()
        let anchor = SCNPhysicsBallSocketJoint(
            bodyA: slideObject.getbottomSlide().physicsBody!,
            anchorA: SCNVector3(x: 0, y: 0, z: -0.0005),
            bodyB: floorObject.getFloor().physicsBody!,
            anchorB: SCNVector3(x: 0, y: 0, z: 0)
        )
        self.physicsWorld.addBehavior(anchor)
        
        //generate link of neck slides
        var cnt: Float = 0.0
        var previousLink: SCNNode = slideObject.getbottomSlide()
        while cnt < 20.0 {
            let link = slideObject.getLink(y: Float(cnt))
            slideObject.links.append(link)
            
            let joint = SCNPhysicsBallSocketJoint(
                bodyA: link.physicsBody!,
                anchorA: SCNVector3(x: 0, y: 0, z: -0.0005),
                bodyB: previousLink.physicsBody!,
                anchorB: SCNVector3(x: 0, y: 0, z: 0.0005)
            )
            self.physicsWorld.addBehavior(joint)
            previousLink = link
            cnt += 0.1
        }
        
        //attach neck slides to head
        let joint = SCNPhysicsBallSocketJoint(
            bodyA: theHead.physicsBody!,
            anchorA: SCNVector3(x: 0, y: 0, z: -0.0005),
            bodyB: previousLink.physicsBody!,
            anchorB: SCNVector3(x: 0, y: 0, z: 0.0005)
        )
        self.physicsWorld.addBehavior(joint)
        
        //add all nodes to scene
        
        slideObject.getHolder().addChildNode(floorObject.getFloor())
        slideObject.getbottomSlide().position = SCNVector3(x: 0, y: 0, z: 0)
        slideObject.getHolder().addChildNode(slideObject.getbottomSlide())
        slideObject.links.forEach { link in
            slideObject.getHolder().addChildNode(link)
        }
//        slideObject.clampLinks()
        self.rootNode.addChildNode(slideObject.getHolder())
        theHead.position = SCNVector3(x: 2.0, y: 4.0, z: 0)
        self.rootNode.addChildNode(theHead)
        self.rootNode.addChildNode(floorObject.getFloor())
        
        
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
        //test if animation can touch leaf (trigger collision)
        let xPosition = Float(0) // Set the range of x position as needed
        let yPosition = Float(5) // Set the range of y position as needed
        let zPosition = Float(0)

//        let xPosition = Float.random(in: -1.5...1.5) // Set the range of x position as needed
//        let yPosition = Float.random(in: -2...2) // Set the range of y position as needed
//        let zPosition = Float.random(in: -5...5) // Set the range of z position as needed
        
        addLeafNode(xPosition: xPosition, yPosition: yPosition, zPosition: zPosition)
    }

    
    func addOmniLight() {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        
        omniLightNode.light?.type = SCNLight.LightType.directional
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
            
            if Float(attitude.pitch) > 3.14 / 4 {
                self!.neckJump()
            }
            
            self?.neckNode?.eulerAngles = SCNVector3(
                x: self!.neckInitialXEulerAngle + Float(attitude.pitch) * 3,
                y: self!.neckInitialYEulerAngle + Float(attitude.roll) * 3,
                z: self!.neckInitialZEulerAngle + Float(attitude.yaw) * 3
            )
            
//            self?.neckNode1?.eulerAngles = SCNVector3(
//                x: self!.neckInitialXEulerAngle + Float(attitude.pitch) * 3,
//                y: self!.neckInitialYEulerAngle + Float(attitude.roll) * 3,
//                z: self!.neckInitialZEulerAngle + Float(attitude.yaw) * 3
//            )
//
//            self?.neckNode2?.eulerAngles = SCNVector3(
//                x: self!.neckInitialXEulerAngle + Float(attitude.pitch) * 3,
//                y: self!.neckInitialYEulerAngle + Float(attitude.roll) * 3,
//                z: self!.neckInitialZEulerAngle + Float(attitude.yaw) * 3
//            )
            
            
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
