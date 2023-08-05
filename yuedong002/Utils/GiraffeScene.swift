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
import SwiftUI
//import calculateObjectState



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
    
    
//    private let motionManager = CMMotionManager()
    private let motionManager = CMHeadphoneMotionManager() //use airpods
    
//    private var planetNode: SCNNode?
    private var neckNode: SCNNode?
    
    private var neckNode1: SCNNode?   // bottom part
    var neckNode2: SCNNode?   //above part
    private var slides = [slide]()
    private var markNode: SCNNode?
    
    private var KAnimationKey: String = "Animation"
    
    
    @Published var leafNode: SCNNode?
    @Published var textNode: SCNNode?
    
    @Published var score: Int = 0
    
    var leafXPosition = Float(1.8)   //initial leaf position
    var leafYPosition = Float(0.0)
    var leafZPosition = Float(0.0)
    
    //neckNode.eulerAngles = SCNVector3(0, -3.14 / 2 + 3.14 / 10, 0) // 设置旋转角度，根据需要调整
    let neckInitialXEulerAngle = Float(0.0)
//    let neckInitialYEulerAngle = Float(-3.14 / 2 - 3.14 / 16)
    let neckInitialYEulerAngle = Float(0.0)
    let neckInitialZEulerAngle = Float(0.0)
    
    let leavesAppearAudioSource = SCNAudioSource(fileNamed: "monoLeavesAppearing.mp3")!
    let leavesEatenAudioSource = SCNAudioSource(fileNamed: "monoGetScore.mp3")!
    var textActionEffectGroup = SCNAction()  //+1 appears and disappears when eat
    var timer: Timer?
    
    @Published var isContacted = false
    @Published var shouldContact = true
     
    
    
    
    override init() {
        super.init()
//        setupAudioEngine()
        
        
        self.physicsWorld.contactDelegate = self   //both this line and next line OK, also can set delegate in View onAppear
//        physicsWorld.contactDelegate = self
        
//        self.physicsWorld.speed = 1.0
        
        self.score = 0
        addBackground()
//        addPlanetNode()
        addNeckNode(neckInitialXEulerAngle: neckInitialXEulerAngle, neckInitialYEulerAngle: neckInitialYEulerAngle, neckInitialZEulerAngle: neckInitialZEulerAngle) // 添加脖子节点
        
//        addNeckNode1(neckInitialXEulerAngle: neckInitialXEulerAngle, neckInitialYEulerAngle: neckInitialYEulerAngle, neckInitialZEulerAngle: neckInitialZEulerAngle)
//        addNeckNode2(neckInitialXEulerAngle: neckInitialXEulerAngle, neckInitialYEulerAngle: neckInitialYEulerAngle, neckInitialZEulerAngle: neckInitialZEulerAngle)
//        addSlides()
        

//        addMarkNode()
        
//        addJoint()
//        spawnNodes()
        
//        loadAnimations()
        
//        addLeafNode(xPosition: leafXPosition, yPosition: leafYPosition, zPosition: leafZPosition)  //添加叶子结点
        configureCamera()
        addOmniLight()
        
        //control rotation
        addNeckRotation()
        
        
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
        backgroundMaterial.lightingModel = .constant
        backgroundMaterial.diffuse.contents = UIImage(named: "gameBackgroundSourceImage") //3000 * 2000
        let backgroundGeometry = SCNPlane(width: 60, height: 40)
        backgroundGeometry.materials = [backgroundMaterial]
        let backgroundNode = SCNNode(geometry: backgroundGeometry)
        backgroundNode.position = SCNVector3(0, 0, -10)
        self.rootNode.addChildNode(backgroundNode)
        
    }
    
    func addNeckNode(neckInitialXEulerAngle: Float, neckInitialYEulerAngle: Float, neckInitialZEulerAngle: Float) {
        guard let scene = SCNScene(named: "单个长颈鹿.dae") else {
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
//        neckNode.eulerAngles = SCNVector3(neckInitialXEulerAngle, neckInitialYEulerAngle, neckInitialZEulerAngle) // 设置旋转角度，根据需要调整
//        neckNode.orientation = SCNVector4(0, 1, 0, -Float.pi / 2) // 设置旋转角度，根据需要调整
//        let rotateAction = SCNAction.rotateBy(x: 0, y: -CGFloat.pi / 2, z: 0, duration: 0)
//        neckNode.runAction(rotateAction)
//        neckNode.rotation = SCNVector4(0, 1, 0, -Float.pi / 2 - Float.pi / 16)
        
        
        
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
    
    func addMarkNode() {
        let markNodeMaterial = SCNMaterial()
        markNodeMaterial.diffuse.contents = UIColor.yellow
        let markNodeGeometry = SCNBox(width: 1, height: 0.1, length: 1, chamferRadius: 0.0)
        markNodeGeometry.materials = [markNodeMaterial]
        let markNode = SCNNode(geometry: markNodeGeometry)
        markNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        markNode.physicsBody?.categoryBitMask = 12 // Set a unique bitmask for the "neck" node
        markNode.physicsBody?.contactTestBitMask = 22 // Set the bitmask of nodes to be notified about contact
//      markNodee2.physicsBody?.mass = 5.0
        markNode.physicsBody?.friction = 0.5
        
        markNode.position = SCNVector3(2, 2, 0)
//        markNode.eulerAngles = SCNVector3(x: neckInitialXEulerAngle, y: neckInitialYEulerAngle, z: neckInitialZEulerAngle)
        markNode.name = "neckNode2"
        self.rootNode.addChildNode(markNode)
        self.markNode = markNode
        
        let markNode2 = SCNNode(geometry: markNodeGeometry)
        markNode2.position = SCNVector3(2, 1, 0)
        self.rootNode.addChildNode(markNode2)
        
    }
    
    func addNeckNode1(neckInitialXEulerAngle: Float, neckInitialYEulerAngle: Float, neckInitialZEulerAngle: Float) {  //bottom part
        let neckNode1Material = SCNMaterial()
        neckNode1Material.diffuse.contents = UIColor.red
        let neckNode1Geometry = SCNBox(width: 1, height: 2, length: 1, chamferRadius: 0.0)
        neckNode1Geometry.materials = [neckNode1Material]
        let neckNode1 = SCNNode(geometry: neckNode1Geometry)
        neckNode1.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        neckNode1.physicsBody?.categoryBitMask = 11 // Set a unique bitmask for the "neck" node
        neckNode1.physicsBody?.contactTestBitMask = 21 // Set the bitmask of nodes to be notified about contact
//        neckNode1.physicsBody?.mass = 5.0
        neckNode1.physicsBody?.friction = 0.5
        neckNode1.position = SCNVector3(0, 0, 0)
        neckNode1.eulerAngles = SCNVector3(x: neckInitialXEulerAngle, y: neckInitialYEulerAngle, z: neckInitialZEulerAngle)
        neckNode1.name = "neckNode1"
        self.rootNode.addChildNode(neckNode1)
        self.neckNode1 = neckNode1
    }
    
    func addNeckNode2(neckInitialXEulerAngle: Float, neckInitialYEulerAngle: Float, neckInitialZEulerAngle: Float) {
        let neckNode2Material = SCNMaterial()
        neckNode2Material.diffuse.contents = UIColor.yellow
        let neckNode2Geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.0)
        neckNode2Geometry.materials = [neckNode2Material]
        let neckNode2 = SCNNode(geometry: neckNode2Geometry)
        neckNode2.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        neckNode2.physicsBody?.categoryBitMask = 12 // Set a unique bitmask for the "neck" node
        neckNode2.physicsBody?.contactTestBitMask = 22 // Set the bitmask of nodes to be notified about contact
//        neckNode2.physicsBody?.mass = 5.0
        neckNode2.physicsBody?.friction = 0.5
        
        neckNode2.position = SCNVector3(0, 2, 0)
        neckNode2.eulerAngles = SCNVector3(x: neckInitialXEulerAngle, y: neckInitialYEulerAngle, z: neckInitialZEulerAngle)
        neckNode2.name = "neckNode2"
        self.rootNode.addChildNode(neckNode2)
        self.neckNode2 = neckNode2
    }
    
    func addSlides() {
        let slideMaterial = SCNMaterial()
        slideMaterial.diffuse.contents = UIColor.gray
        let slideGeometry = SCNBox(width: 1, height: 0.1, length: 1, chamferRadius: 0.5)
        slideGeometry.materials = [slideMaterial]
        
        
        
        var headPositionInfo = solveHeadPosition(
            neckLength: 2.0,
            pitch: (self.neckNode2!.eulerAngles.x),
            roll: (self.neckNode2!.eulerAngles.z)
        ) //return (x, y, z, theta, phi)
        print("necknode2 eulerangles: ", self.neckNode2!.eulerAngles)
        
        
        print("self.neckNode1?.geometry?.accessibilityFrame.height: ", self.neckNode1?.geometry?.accessibilityFrame.height)
        print("self.neckNode2?.geometry?.accessibilityFrame.height: ", self.neckNode2?.geometry?.accessibilityFrame.height)
        
        var slidesInfo = solveNeckSlides(
            SlidesNum: 10,
            theta: headPositionInfo.theta,
            phi: headPositionInfo.phi,
            headPosition: SCNVector3(x: headPositionInfo.x, y: headPositionInfo.y, z: headPositionInfo.z),
            headHeight: 1.0,
            neckPosition: SCNVector3(x: 0, y: 0, z: 0),
            neckHeight: 2.0
        )   // return an array [slide]
        
        var i = 0
        while i < 10 {
            let slide = SCNNode(geometry: slideGeometry)
            slide.position = SCNVector3(x: Float(slidesInfo[i].x), y: Float(slidesInfo[i].y), z: Float(slidesInfo[i].z) )
            slide.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            slide.physicsBody?.categoryBitMask = 1 // Set a unique bitmask for the "neck" node
            slide.physicsBody?.contactTestBitMask = 2 // Set the bitmask of nodes to be notified about contact
            slide.physicsBody?.collisionBitMask = 2
            self.rootNode.addChildNode(slide)
        }
         
//        slide1.position = SCNVector3(0, 0, 0)
//        slide1.name = "slide1"
//        self.rootNode.addChildNode(slide1)
        
    }
    

    
    func addLeafNode(xPosition: Float, yPosition: Float, zPosition: Float) {
        
        let leafMaterial = SCNMaterial()
        leafMaterial.diffuse.contents = UIImage(named: "leaf")
        leafMaterial.lightingModel = .constant  //not affected by light

        let leafGeometry = SCNPlane(width: 1.0, height: 1.0)
        leafGeometry.materials = [leafMaterial]
        
        let leafNode = SCNNode(geometry: leafGeometry)
        leafNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        leafNode.physicsBody?.categoryBitMask = 2 // Set a unique bitmask for the "leaf" node
        leafNode.physicsBody?.contactTestBitMask = 1  // Set the bitmask of nodes to be notified about contact
        
        leafNode.position = SCNVector3(x: xPosition, y: yPosition, z: zPosition)
        leafNode.name = "leaf"
        
        //appear audio setting
        self.leavesAppearAudioSource.isPositional = true // Enable 3D spatialization
        self.leavesAppearAudioSource.shouldStream = false // Use streaming for longer audio files
        self.leavesAppearAudioSource.volume = 1.0
        leafNode.addAudioPlayer(SCNAudioPlayer(source: leavesAppearAudioSource))
        
        //eaten(get score) audio setting
        self.leavesEatenAudioSource.isPositional = true
        self.leavesEatenAudioSource.shouldStream = false
        self.leavesEatenAudioSource.volume = 1.0
        leafNode.addAudioPlayer(SCNAudioPlayer(source: leavesEatenAudioSource))
        
        self.rootNode.addChildNode(leafNode)
        self.leafNode = leafNode
        
        //SCNtext +1
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIColor(red: 0.41, green: 0.63, blue: 0.16, alpha: 0.38)
        let textGeometry = SCNText(string: "+1", extrusionDepth: 0.2)
//        textGeometry.font = UIFont(name: "DFPYuanW9", size: 1.0)
        textGeometry.materials = [textMaterial]
        
        let textNode = SCNNode(geometry: textGeometry)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        let textXPosition = Float((self.leafNode?.position.x)!) + 0.04
        let textYPosition = Float((self.leafNode?.position.y)!) + 0.04
        let textZPosition = Float(4.0)
        textNode.position = SCNVector3(x: textXPosition, y: textYPosition, z: textZPosition)
        
        textNode.opacity = 0.0
        let fadeInAction = SCNAction.fadeOpacity(to: 0.8, duration: 0.4)
        let fadeOutAction = SCNAction.fadeOpacity(to: 0.0, duration: 0.4)
        self.textActionEffectGroup = SCNAction.sequence([fadeInAction, fadeOutAction])
//        textNode.runAction(actionEffectGroup)  //when eat
        
        self.rootNode.addChildNode(textNode)  //add +1 text into scene
        self.textNode = textNode
        
    }
    
    func removeLeafNode() {
        print("parent of leaf: ", self.leafNode!.parent)
        self.leafNode!.removeFromParentNode()
        self.textNode!.removeFromParentNode()
    }

    func changeLeafNodePosition() {
        //test if animation can touch leaf (trigger collision)
//        let xPosition = Float(-2.0) // Set the range of x position as needed
//        let yPosition = Float(0) // Set the range of y position as needed
        let zPosition = Float(0)

        let xPosition = Float.random(in: -1.5...1.5) // Set the range of x position as needed
        let yPosition = Float.random(in: -2...2)
//        let zPosition = Float.random(in: -5...5)
        self.leafNode?.position = SCNVector3(x: xPosition, y: yPosition, z: zPosition)
        self.leafNode?.runAction(SCNAction.playAudio(self.leavesAppearAudioSource, waitForCompletion: false))
        
        self.textNode?.position = SCNVector3(x: xPosition + 0.04, y: yPosition + 0.04, z: 4.0)
    }
    
    func addEatenEffect() {
        self.textNode?.runAction(self.textActionEffectGroup) //+1 appear and disappear
        self.leafNode?.runAction(SCNAction.playAudio(self.leavesEatenAudioSource, waitForCompletion: false))
    }

    
    func addOmniLight() {
        let omniLightNode1 = SCNNode()
        omniLightNode1.light = SCNLight()
        
        omniLightNode1.light?.type = SCNLight.LightType.directional
        omniLightNode1.light?.color = UIColor(white: 1.0, alpha: 0.9)
        omniLightNode1.position = SCNVector3Make(-10, 10, 20)
        
        let omniLightNode2 = omniLightNode1.clone()
        omniLightNode2.position = SCNVector3(10, 10, 20)
        
        let omniLightNode3 = omniLightNode1.clone()
        omniLightNode3.position = SCNVector3(0, 0, 20)
        
        self.rootNode.addChildNode(omniLightNode1)
        self.rootNode.addChildNode(omniLightNode2)
        self.rootNode.addChildNode(omniLightNode3)
    }

    
    
    func addNeckRotation() {
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] deviceMotion, error in
            guard let attitude = deviceMotion?.attitude else { return }
                        
            
            self?.neckNode?.eulerAngles = SCNVector3(
                x: self!.neckInitialXEulerAngle - Float(attitude.pitch),
                y: 0,
                z: self!.neckInitialZEulerAngle - Float(attitude.roll)
            )
            
        }
    }
    
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
//        print("contact begin time: ", Date())
        
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        print("contact update")
        if ((contact.nodeA.name == "neck" && contact.nodeB.name == "leaf") || (contact.nodeA.name == "leaf" && contact.nodeB.name == "neck")) {
            // get 1 score when "neck" and "leaf" collide
            self.score += 1
            print("score: \(self.score)" )
            self.addEatenEffect()
            
            physicsWorld.contactDelegate = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { //最快0.25秒进行一次碰撞检测
                if self.shouldContact {
                    self.isContacted.toggle()
                    self.physicsWorld.contactDelegate = self
                        
                    print("延时执行时间：\(Date())")
                }
                
            }
                       
            
        }
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        print("contact end")
    }
    
    
}
