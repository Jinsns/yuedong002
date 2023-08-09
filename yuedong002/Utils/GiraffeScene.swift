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
    
    @Published var cameraNode: SCNNode?
    
    private var neckNode: SCNNode?
    private var backgroundNode: SCNNode?
    
    private var KAnimationKey: String = "Animation"
    
    
    @Published var leafNode: SCNNode?
    @Published var textNode: SCNNode?
    
    @Published var score: Int = 0
    
    var leafXPosition = Float(1.8)   //initial leaf position
    var leafYPosition = Float(0.0)
    var leafZPosition = Float(0.0)
    
    //neckNode.eulerAngles = SCNVector3(0, -3.14 / 2 + 3.14 / 10, 0) // 设置旋转角度，根据需要调整
//    let neckInitialYEulerAngle = Float(-3.14 / 2 - 3.14 / 16)
    
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
        
        // 添加脖子节点
        addNeckNode(
            neckInitialXEulerAngle: 0,
            neckInitialYEulerAngle: 0,
            neckInitialZEulerAngle: 0
        )
        
//        loadAnimations()
        
//        configureCamera()
        addCameraNode()
        addOmniLight()
        
        //control rotation
        addNeckRotation()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configureCamera() {
//        self.rootNode.position = SCNVector3(x: 0.0, y: -1, z: -8)
//    }
    
    func addCameraNode() {
        let cameraNode = SCNNode()
        let camera = SCNCamera()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 10, y: 2, z: 0) //y=9就能看见背景图片外的空白了
            //y=-3就能看见脖子底部了
            //所以y的整数区间是 [-2, 8]
        
        //rotation
        //x增大，视角上仰看天；
        //y增大，视角从左看向右；
        //z增大，场景顺时针转动
        let cameraRotation = SCNVector3(x: -0.0, y: +1.60, z: 0.0)
        
        cameraNode.eulerAngles = cameraRotation
        self.rootNode.addChildNode(cameraNode)
        self.cameraNode = cameraNode
    }
    
    func moveCameraNodeSmoothly(newPosition: SCNVector3) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.2
        self.cameraNode?.position = newPosition
        SCNTransaction.commit()
    }
    
    func moveCameraNodeAndNeckNodeToShopPosition() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.2
        self.cameraNode?.position = SCNVector3(x: 5, y: 2, z: -12)
        self.neckNode?.position = SCNVector3(x: -5, y: -3 , z: -11)   //x大 屏幕外，z大 屏幕左
        SCNTransaction.commit()
    }
    
    func moveCameraNodeAndNeckNodeToGamePosition() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.2
        self.cameraNode?.position = SCNVector3(x: 10, y: 2, z: 0)
        self.neckNode?.position = SCNVector3(0, -3, 0)
        SCNTransaction.commit()
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
        backgroundNode.position = SCNVector3(-10, 0, 0)
        backgroundNode.eulerAngles = SCNVector3(x: 0, y: Float.pi / 2, z: 0)
        
//        backgroundNode.categoryBitMask = LightType.onBackground
        self.rootNode.addChildNode(backgroundNode)
        self.backgroundNode = backgroundNode
        self.backgroundNode?.categoryBitMask = LightType.onBackground
        
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
        neckNode.categoryBitMask = LightType.onNeck
        neckNode.geometry?.materials.first?.lightingModel = .phong
        self.rootNode.addChildNode(neckNode)
        self.neckNode = neckNode
        
    
    }

    
    func addLeafNode(xPosition: Float, yPosition: Float, zPosition: Float, level: Int) {
        
//        guard let scene = SCNScene(named: "eatLeafNoLight") else {
//            print("Failed to load 'eatLeafNoLight'")
//            return
//        }
//        
//        guard let leafNode = scene.rootNode.childNodes.first else {
//            print("Failed to find the first child node in 'eatLeafNoLight'")
//            return
//        }
        
        
        let leafMaterial = SCNMaterial()
        if level == 1 {
            leafMaterial.diffuse.contents = UIImage(named: "leaf")
        } else if level == 2 {
            leafMaterial.diffuse.contents = UIImage(named: "SettingsButton")
        } else if level == 3 {
            leafMaterial.diffuse.contents = UIImage(named: "PhotoIcon")
        }

        leafMaterial.lightingModel = .constant  //not affected by light

        let leafGeometry = SCNPlane(width: 1.0, height: 1.0)
        leafGeometry.materials = [leafMaterial]

        let leafNode = SCNNode(geometry: leafGeometry)
        
        leafNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        leafNode.physicsBody?.categoryBitMask = 2 // Set a unique bitmask for the "leaf" node
        leafNode.physicsBody?.contactTestBitMask = 1  // Set the bitmask of nodes to be notified about contact
        
        leafNode.position = SCNVector3(x: xPosition, y: yPosition, z: zPosition)
        leafNode.eulerAngles = SCNVector3(0, Float.pi / 2, 0)
//        leafNode.eulerAngles = SCNVector3(0, 0, 0)
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
        self.leafNode?.runAction(SCNAction.playAudio(self.leavesAppearAudioSource, waitForCompletion: false))
        
//        //SCNtext +1
//        let textMaterial = SCNMaterial()
//        textMaterial.diffuse.contents = UIColor(red: 0.41, green: 0.63, blue: 0.16, alpha: 0.38)
//        let textGeometry = SCNText(string: "+1", extrusionDepth: 0.2)
////        textGeometry.font = UIFont(name: "DFPYuanW9", size: 1.0)
//        textGeometry.materials = [textMaterial]
//
//        let textNode = SCNNode(geometry: textGeometry)
//        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
//        let textXPosition = Float((self.leafNode?.position.x)!) + 0.04
//        let textYPosition = Float((self.leafNode?.position.y)!) + 0.04
//        let textZPosition = Float(4.0)
//        textNode.position = SCNVector3(x: textXPosition, y: textYPosition, z: textZPosition)
//
//        textNode.opacity = 0.0
//        let fadeInAction = SCNAction.fadeOpacity(to: 0.8, duration: 0.4)
//        let fadeOutAction = SCNAction.fadeOpacity(to: 0.0, duration: 0.4)
//        self.textActionEffectGroup = SCNAction.sequence([fadeInAction, fadeOutAction])
////        textNode.runAction(actionEffectGroup)  //when eat
//
//        self.rootNode.addChildNode(textNode)  //add +1 text into scene
//        self.textNode = textNode
        
        
    }
    
    func loadLeafAnimation() {
        var animationGroups: [CAAnimation] = []
        if let url = Bundle.main.url(forResource: "eatLeafNoLight", withExtension: "dae") {
            let sceneSource = SCNSceneSource(url: url, options: [:])
            let animationIDs = sceneSource?.identifiersOfEntries(withClass: CAAnimation.self)
            var maxDuration: CFTimeInterval = 0.0
            if let animations = animationIDs {
                for item in animations {
                    print("animation1: \(item)")
                    if let ani = sceneSource?.entryWithIdentifier(item, withClass: CAAnimation.self) {
                        maxDuration = max(maxDuration, ani.duration)
                        animationGroups.append(ani)
                    }
                }
            }
            
            let group = CAAnimationGroup()
            group.animations = animationGroups
            group.duration = maxDuration
            group.repeatCount = MAXFLOAT
            group.autoreverses = false
            self.leafNode?.addAnimation(group, forKey: "leafEatenAnimation")
            
        }
    }
    
    func removeLeafNode() {
        print("parent of leaf: ", self.leafNode!.parent)
        self.leafNode!.removeFromParentNode()
//        self.textNode!.removeFromParentNode()
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
    
    func runEatenEffect() {
//        self.textNode?.runAction(self.textActionEffectGroup) //+1 appear and disappear
//        loadLeafAnimation()
        self.leafNode?.runAction(SCNAction.playAudio(self.leavesEatenAudioSource, waitForCompletion: false))
    }

    
    func addOmniLight() {
        self.neckNode?.geometry?.materials.first?.lightingModel = .phong
        let omniLightNode1 = SCNNode()
        omniLightNode1.light = SCNLight()
        omniLightNode1.light?.type = SCNLight.LightType.omni
        omniLightNode1.light?.color = UIColor(white: 1.0, alpha: 0.9)
        omniLightNode1.position = SCNVector3Make(10, 5, 0)  //x大 屏幕外，y大 屏幕上，z大 屏幕左
        omniLightNode1.eulerAngles = SCNVector3Make(0, Float.pi / 2, 0)
        omniLightNode1.light?.categoryBitMask = LightType.onNeck
        omniLightNode1.light?.intensity = 1000
        
        let omniLightNode2 = SCNNode()
        omniLightNode2.light = SCNLight()
        omniLightNode2.light?.type = SCNLight.LightType.omni
        omniLightNode2.light?.color = UIColor(white: 1.0, alpha: 0.9)
        omniLightNode2.position = SCNVector3(10, 5, -2)
        omniLightNode2.eulerAngles = SCNVector3Make(0, Float.pi / 2, 0)
        omniLightNode2.light?.categoryBitMask = LightType.onNeck

        let omniLightNode3 = SCNNode()
        omniLightNode3.light = SCNLight()
        omniLightNode3.light?.type = SCNLight.LightType.omni
        omniLightNode3.light?.color = UIColor(white: 1.0, alpha: 0.9)
        omniLightNode3.position = SCNVector3(10, 5, 2)
        omniLightNode3.eulerAngles = SCNVector3Make(0, Float.pi / 2, 0)
        omniLightNode3.light?.categoryBitMask = LightType.onNeck
        
        self.rootNode.addChildNode(omniLightNode1)
        self.rootNode.addChildNode(omniLightNode2)
        self.rootNode.addChildNode(omniLightNode3)
        
    }
    
    func addExtraLight() {
        self.backgroundNode?.geometry?.materials.first?.lightingModel = .phong    //change background material lignting model here.
        let extraLightNode = SCNNode()
        extraLightNode.light = SCNLight()
        extraLightNode.light?.type = SCNLight.LightType.directional
        extraLightNode.light?.color = UIColor(red: 0.97, green: 1, blue: 0.76, alpha: 0.2)
        extraLightNode.light?.intensity = 600
        extraLightNode.position = SCNVector3(0, -1, -20)
        extraLightNode.eulerAngles = SCNVector3(0, Float.pi / 2, 0)
        extraLightNode.light?.categoryBitMask = LightType.onBackground
        var extraLightNode2 = SCNNode()
        extraLightNode2 = extraLightNode.clone()
        extraLightNode2.position = SCNVector3(0, 1, -20)
        extraLightNode2.light?.categoryBitMask = LightType.onBackground
        self.rootNode.addChildNode(extraLightNode)
        self.rootNode.addChildNode(extraLightNode2)
    }

    
    
    func addNeckRotation() {
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] deviceMotion, error in
            guard let attitude = deviceMotion?.attitude else { return }
            let absx: Float = abs(Float(attitude.roll))
            let absz: Float = abs(Float(attitude.pitch))
            let maxAngle = Float.pi / 8
                        
            
            self?.neckNode?.eulerAngles = SCNVector3(
                x:  absx > maxAngle ? maxAngle * (-Float(attitude.roll)) / absx : -Float(attitude.roll),
                y: 0,
                z: absz > maxAngle ? maxAngle * (Float(attitude.pitch)) / absz : Float(attitude.pitch)
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
//            self.score += 1   //operate in SwiftUIView
//            self.runEatenEffect()
            
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


struct LightType {
    static let onNeck: Int = 0x1 << 1
    static let onBackground: Int = 0x1 << 2
}
