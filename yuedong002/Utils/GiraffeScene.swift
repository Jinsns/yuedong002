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
    let motionManager = CMHeadphoneMotionManager() //use airpods
    let iphoneMotionManager = CMMotionManager()  //use iphone to control camera view angle in snapview
    
    @Published var isAirpodsAvailable: Bool = false
    @Published var headphoneAnglex: Double = 0.0
    @Published var headphoneAnglez: Double = 0.0
    @Published var isPositionReady: Bool = false
    
    @Published var cameraNode: SCNNode?
    
    private var neckNode: SCNNode?
    private var ornamentNode: SCNNode?
    private var backgroundNode: SCNNode?
    private var cloudNode: SCNNode?
    @Published var inWorld: Int = 1
    
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
    let leavesEatenAudioSource = SCNAudioSource(fileNamed: "monoGetScore0811.mp3")!
    var textActionEffectGroup = SCNAction()  //+1 appears and disappears when eat
    var timer: Timer?
    
    @Published var isContacted = false
//    @Published var shouldContact = true
    @Published var isContacting = false
    
    @Published var extraLightNode1: SCNNode?
    @Published var extraLightNode2: SCNNode?
    
     
    
    
    
    override init() {
        super.init()
//        setupAudioEngine()
        
        
        self.physicsWorld.contactDelegate = nil   //both this line and next line OK, also can set delegate in View onAppear
//        physicsWorld.contactDelegate = self
        
//        self.physicsWorld.speed = 1.0
        
        self.score = 0
        addBackground()
        
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
        
//        upWorld() //only for testing
        
        
        //control rotation
//        addNeckRotation()
        
//        addExtraLight()  //only for testing
        
        
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
    
//    func moveCameraNodeSmoothly(newPosition: SCNVector3) {
////        //originalposition of cloud
////        //cloudNode.position = SCNVector3(1, 9.4, 0)
//        var cloudNewPositionY: Float = 9.4
//        if newPosition.y == 8.0 {
//            cloudNewPositionY = 7.4//down to the border between two world
//        } else if newPosition.y <= 2.0 {
//            cloudNewPositionY = 9.4   //back to originalPosition
//        }
//
////        SCNTransaction.begin()
////        SCNTransaction.animationDuration = 1.2
////        self.cameraNode?.position = newPosition
////        self.cloudNode?.position = SCNVector3(x: 1, y: cloudNewPositionY, z: 0)
////        SCNTransaction.commit()
//
//        if newPosition.y >= 2.0 {
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 1.2
//            self.cameraNode?.position = newPosition
//            self.cloudNode?.position = SCNVector3(x: 1, y: cloudNewPositionY, z: 0)
//            SCNTransaction.commit()
//        } else { //go down world
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 0.6
//            self.neckNode?.position = SCNVector3(x: 0.0, y: -3.0, z: 0.0)
//
//            SCNTransaction.completionBlock = {
//                SCNTransaction.begin()
//                SCNTransaction.animationDuration = 1.2
//                self.backgroundNode?.position = SCNVector3(x: -35, y: 100, z: 0)
//                self.cloudNode?.position = SCNVector3(x: 1, y: cloudNewPositionY, z: 0)
//                self.neckNode?.position = SCNVector3(x: 0.0, y: -2.8, z: 0.0)
//                SCNTransaction.commit()
//            }
//
//            SCNTransaction.commit()
//        }
//    }
    
    /* 在“地面”，有三种状态，下，中，上
     从中到下时，camera下移，背景和鹿不动
     从下到中时，camera上一到中间位置，背景和鹿不懂
     从中到上时，camera上移，背景和鹿不动
     从上到中时，camera回到中间位置，背景和鹿不懂
     */
    
//     初始位置
//    cameraNode.position = SCNVector3(x: 10, y: 2, z: 0)
//    cloudNode.position = SCNVector3(1, 9.4, 0)
//    backgroundNode.position = SCNVector3(-35, 114, 0)    //original
//    self.backgroundNode?.position = SCNVector3(-35, 66, 0) // in world 2
//    giraffeNode10.position = SCNVector3(0.0, -3.2, 0.0)

    
    func world1ViewMid2Up() {
        rotateBackNeckNode()
        stopMotionUpdates()

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.2
        self.cameraNode?.position = SCNVector3(x: 10, y: 9.0, z: 0)
//        self.cloudNode?.position = SCNVector3(x: 1, y: 7.4, z: 0)  //先不动云的位置试试视觉效果
        SCNTransaction.commit()
    }
    
    func world1ViewUp2Mid() {
        addNeckRotation()
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.2
        self.cameraNode?.position = SCNVector3(x: 10, y: 2.0, z: 0)
//        self.cloudNode?.position = SCNVector3(x: 1, y: 9.4, z: 0)
        SCNTransaction.commit()
    }
    
    func world1ViewMid2Down() {
        rotateBackNeckNode()
        stopMotionUpdates()
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.2
        self.cameraNode?.position = SCNVector3(x: 10, y: -2.0, z: 0)
        SCNTransaction.commit()
    }
    
    func world1ViewDown2Mid() {
        addNeckRotation()
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.2
        self.cameraNode?.position = SCNVector3(x: 10, y: 2.0, z: 0)
        SCNTransaction.commit()
    }
    
    /*
     在“云中秘境”，有三种状态，下，中，上
     从中到下时（到能看到脖子和地面的风景），背景上移 + camera下移，鹿不动
     从下到中时，背景下移 + camera上移，鹿不动
     从中到上时，camera上移，背景和鹿不懂
     从上到中时，camera回到中间位置，背景和鹿不动
     */
    
    func world2ViewMid2Up() {
        world1ViewMid2Up()
    }
    
    func world2ViewUp2Mid() {
        world1ViewUp2Mid()
    }
    
    func world2ViewMid2Down() {
        rotateBackNeckNode()
        stopMotionUpdates()
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.6
        self.cameraNode?.position = SCNVector3(x: 10, y: 1.0, z: 0)
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.2
            self.backgroundNode?.position = SCNVector3(x: -35, y: 107, z: 0)    //back to original position
            self.neckNode?.position = SCNVector3(x: 0.0, y: 6.0, z: 0 )//长颈鹿上去才能看到下面的脖子
            self.cameraNode?.position = SCNVector3(x: 10, y: 2.0, z: 0)
            SCNTransaction.commit()
        }
        SCNTransaction.commit()
    }
    
    func world2ViewDown2Mid() {
        addNeckRotation()
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.6
        self.cameraNode?.position = SCNVector3(x: 10, y: 3.0, z: 0)
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.2
            self.neckNode?.position = SCNVector3(x: 0.0, y: -2.8, z: 0)
            self.backgroundNode?.position = SCNVector3(x: -35, y: 47, z: 0)  //from 66 -> 52 -> 59 -> 47
            self.cameraNode?.position = SCNVector3(x: 10, y: 2.0, z: 0.0)
            SCNTransaction.commit()
        }
        SCNTransaction.commit()
    }
    
    
    
    
//    func moveCameraNodeUp2() {  //2 means worldname == 云中秘境
//        //original cameranode position SCNVector3(x: 10, y: 2, z: 0)
//        SCNTransaction.begin()
//        SCNTransaction.animationDuration = 1.2
//        if self.inWorld == 1 {
//            self.cameraNode!.position = SCNVector3(x: 10, y: 20, z: 0 )
//            self.backgroundNode?.position = SCNVector3(-35, 66, 0)
//        } else if self.inWorld == 2 {
//            self.cameraNode!.position = SCNVector3(x: 10, y: 8.0, z: 0)
//            self.backgroundNode?.position = SCNVector3(-35, 66, 0)
//        }
//        SCNTransaction.commit()
//        self.inWorld = 2
//    }
    
//    func moveCameraNodeDown2() { //2 means worldname == 云中秘境
//
//        SCNTransaction.begin()
//        SCNTransaction.animationDuration = 1.2
//        if self.inWorld == 1 {
//            self.cameraNode!.position = SCNVector3(x: 10, y: -1.5, z: 0)
//        } else if self.inWorld == 2 {
//            self.cameraNode!.position = SCNVector3(x: 10, y: -14, z: 0)
//            self.backgroundNode?.position = SCNVector3(x: -35, y: 90, z: 0)
//        }
//        SCNTransaction.commit()
//        self.inWorld = 1
//    }
    
    
    func moveCameraNodeAndNeckNodeToShopPosition() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.2
        self.cameraNode?.position = SCNVector3(x: 5, y: 2, z: -12)
        self.neckNode?.position = SCNVector3(x: -5, y: -1.6 , z: -11)   //x大 屏幕外，z大 屏幕左
        SCNTransaction.commit()
    }
    
    func moveCameraNodeAndNeckNodeToGamePosition() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.2
        self.cameraNode?.position = SCNVector3(x: 10, y: 2, z: 0)
        self.neckNode?.position = SCNVector3(0.0, -2.8, 0)
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
//        backgroundMaterial.diffuse.contents = UIImage(named: "gameBackgroundSourceImage") //3000 * 2000
//        backgroundMaterial.diffuse.contents = UIImage(named: "LongBackGround2") //3000 * 2000
        backgroundMaterial.diffuse.contents = UIImage(named: "bg0822") //3000 * 2000
        let backgroundGeometry = SCNPlane(width: 60, height: 284.44)
        backgroundGeometry.materials = [backgroundMaterial]
        let backgroundNode = SCNNode(geometry: backgroundGeometry)
        backgroundNode.position = SCNVector3(-35, 107, 0)    //original   y: from 114 -> 100 -> 107
//        backgroundNode.position = SCNVector3(-35, 66, 0)    //test move
        backgroundNode.eulerAngles = SCNVector3(x: 0, y: Float.pi / 2, z: 0)
        
//        backgroundNode.categoryBitMask = LightType.onBackground
        self.rootNode.addChildNode(backgroundNode)
        self.backgroundNode = backgroundNode
        self.backgroundNode?.categoryBitMask = LightType.onBackground
        
        let cloudMaterial = SCNMaterial()
        cloudMaterial.lightingModel = .constant
        cloudMaterial.diffuse.contents = UIImage(named: "clouds")
        if let image = UIImage(named: "clouds") {
            //want width = 60, calculate corresponding height
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            let aspectRatio = imageWidth / imageHeight
            let desiredPlaneWidth: CGFloat = 24.0
            let desiredPlaneHeight = desiredPlaneWidth / aspectRatio
            
            let cloudGeometry = SCNPlane(width: desiredPlaneWidth, height: desiredPlaneHeight)
            cloudGeometry.materials = [cloudMaterial]
            let cloudNode = SCNNode(geometry: cloudGeometry)
            cloudNode.position = SCNVector3(1, 9.4, 0)
//            cloudNode.position = SCNVector3(1, -6.4, 0)
            cloudNode.eulerAngles = SCNVector3(x: 0, y: Float.pi / 2, z: 0)
            self.rootNode.addChildNode(cloudNode)
            self.cloudNode = cloudNode
        }
        
    }
    
    func upWorld() {
        self.inWorld = 2
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.6
        self.neckNode?.position = SCNVector3(0.0, 1.5, 0.0)
        
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.2
            
            //原来在 giraffeNode10.position = SCNVector3(0.0, -1.8, 0.0)
    //        self.neckNode?.position = SCNVector3(0.0, 5, 0.0)
            self.backgroundNode?.position = SCNVector3(-35, 47, 0)
            self.cloudNode?.position = SCNVector3(1, -6.4, 0)
            self.neckNode?.position = SCNVector3(0.0, -2.8, 0.0)
            SCNTransaction.commit()
        }
        SCNTransaction.commit()
    }
    
    func addNeckNode(neckInitialXEulerAngle: Float, neckInitialYEulerAngle: Float, neckInitialZEulerAngle: Float) {
        guard let scene = SCNScene(named: "长颈鹿0816.dae") else {
            print("Failed to load 'giraffe0.dae'")
            return
        }
        
        print("scene.rootNode.childNodes: ", scene.rootNode.childNodes)
        let neckNode = scene.rootNode
        
        // 根据需要对脖子模型进行缩放和位置调整
        //in game position: self.neckNode?.position = SCNVector3(0.0, -3.2, 0)
        neckNode.scale = SCNVector3(1.0, 1.0, 1.0)   //缩放
        neckNode.position = SCNVector3(0.0, -3.2, 0.0) // 设置位置，根据需要调整
        neckNode.eulerAngles = SCNVector3(neckInitialXEulerAngle, neckInitialYEulerAngle, neckInitialZEulerAngle) // 设置旋转角度，根据需要调整


        neckNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)  //if both neck and leaf are .statgiffecan't collide
        neckNode.physicsBody?.categoryBitMask = 1 // Set a unique bitmask for the "neck" node
        neckNode.physicsBody?.contactTestBitMask = 2 // Set the bitmask of nodes to be notified about contact
        neckNode.name = "neck"
        
        neckNode.geometry?.materials.first?.lightingModel = .constant
        neckNode.categoryBitMask = LightType.onNeck
        
        self.rootNode.addChildNode(neckNode)
        self.neckNode = neckNode
        
    
    }
    
    func addOrnament(ornamentName: String) {
        self.ornamentNode?.removeFromParentNode()
        
        var scene: SCNScene?
        var ornament: SCNNode!
        if ornamentName == "墨镜" {
            scene = SCNScene(named: "墨镜0827.dae")!
            ornament = scene!.rootNode
            ornament.scale = SCNVector3(0.8, 0.8, 0.8)
            ornament.position = SCNVector3(x: 1.0, y: 5.36, z: 0.08)
//            ornament.eulerAngles = SCNVector3(x: 0, y: Float.pi / 2, z: Float.pi / 2)
            
        } else if ornamentName == "戒指" {
            scene = SCNScene(named: "戒指0822.dae")!
            ornament = scene!.rootNode
            ornament.scale = SCNVector3(0.92, 0.92, 0.92)
            ornament.position = SCNVector3(x: 0.15, y: 3 , z: 0.28)
        } else if ornamentName == "天使" {
            scene = SCNScene(named: "天使.dae")!
            ornament = scene!.rootNode
            
            let rootNode = scene!.rootNode
            var geometryNode: SCNNode?
            for childNode in rootNode.childNodes {
                if childNode.geometry != nil {
                    geometryNode = childNode
                    break
                }
            }
            if let ornamentGeometry = geometryNode?.geometry {
                print("found geometry: ", ornamentGeometry)
                let ornamentMaterial1 = SCNMaterial()
                ornamentMaterial1.diffuse.contents = UIImage(named: "angleskin")
                ornamentMaterial1.lightingModel = .lambert
                ornamentGeometry.materials = [ornamentMaterial1]
                ornament = SCNNode(geometry: ornamentGeometry)
            } else {
                print("no geometry found")
            }
            ornament.categoryBitMask = LightType.onNeck
            
            ornament.scale = SCNVector3(0.5, 0.5, 0.5)
            ornament.position = SCNVector3(x: 0, y: 6.4, z: 0.21)
            ornament.eulerAngles = SCNVector3(x: 0, y: Float.pi / 2, z: 0)
        } else if ornamentName == "香蕉" {
            scene = SCNScene(named: "香蕉.dae")!
            ornament = scene!.rootNode
            let rootNode = scene!.rootNode
            var geometryNode: SCNNode?
            for childNode in rootNode.childNodes {
                if childNode.geometry != nil {
                    geometryNode = childNode
                    break
                }
            }
            if let ornamentGeometry = geometryNode?.geometry {
                print("found geometry: ", ornamentGeometry)
                let ornamentMaterial1 = SCNMaterial()
                ornamentMaterial1.diffuse.contents = UIColor(.yellow)
                ornamentMaterial1.lightingModel = .lambert
                let ornamentMaterial2 = SCNMaterial()
                ornamentMaterial2.diffuse.contents = UIColor(.red)
                ornamentMaterial2.lightingModel = .lambert
                ornamentGeometry.materials = [ornamentMaterial1, ornamentMaterial2]
                ornament = SCNNode(geometry: ornamentGeometry)
            } else {
                print("no geometry found")
            }
            
            ornament.scale = SCNVector3(0.2, 0.2, 0.2)
            ornament.position = SCNVector3(x: 0.25, y: 5.7, z: 0.3)
            ornament.eulerAngles = SCNVector3(x: Float.pi , y: 0, z: -Float.pi / 2)
            ornament.categoryBitMask = LightType.onNeck
        } else if ornamentName == "椰子树" {
            scene = SCNScene(named: "椰子树.dae")!
            ornament = scene!.rootNode
            let rootNode = scene!.rootNode
            var geometryNode: SCNNode?
            for childNode in rootNode.childNodes {
                if childNode.geometry != nil {
                    geometryNode = childNode
                    break
                }
            }
            if let ornamentGeometry = geometryNode?.geometry {
                print("found geometry: ", ornamentGeometry)
                let ornamentMaterial1 = SCNMaterial()
                ornamentMaterial1.diffuse.contents = UIColor(.gray)
                ornamentMaterial1.lightingModel = .lambert
                let ornamentMaterial2 = SCNMaterial()
                ornamentMaterial2.diffuse.contents = UIColor(.green)
                ornamentMaterial2.lightingModel = .lambert
                ornamentGeometry.materials = [ornamentMaterial1, ornamentMaterial2]
                ornament = SCNNode(geometry: ornamentGeometry)
            } else {
                print("no geometry found")
            }
            
            ornament.scale = SCNVector3(1.4, 1.4, 1.4)
            ornament.position = SCNVector3(x: -2.0, y: 5.8, z: 0.4)
            ornament.eulerAngles = SCNVector3(x: 0, y: -Float.pi / 2, z: 0)
            ornament.categoryBitMask = LightType.onNeck
            
            // self.backgroundNode?.geometry?.materials.first?.lightingModel = .lambert
        }
        

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.4
        self.ornamentNode = ornament
        self.neckNode?.addChildNode(ornament)
//        self.rootNode.addChildNode(ornament)
        
        SCNTransaction.commit()
    }
    
    func rotateBackNeckNode() {
        self.neckNode?.eulerAngles = SCNVector3(x: 0, y: 0, z: 0)
    }

    
    func addLeafNode(xPosition: Float, yPosition: Float, zPosition: Float, level: Int, noteUIPosition: String) {
        
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
        leafMaterial.transparency = 0.0
//        let leafGeometry = SCNPlane(width: 1.6, height: 1.6)
//        let leafGeometry = SCNPlane(width: 6, height: 6)
        let leafGeometry = SCNBox(width: 6, height: 3, length: 3, chamferRadius: 0)
        
        leafGeometry.materials = [leafMaterial]

        let leafNode = SCNNode(geometry: leafGeometry)
        
        leafNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        leafNode.physicsBody?.categoryBitMask = 2 // Set a unique bitmask for the "leaf" node
        leafNode.physicsBody?.contactTestBitMask = 1  // Set the bitmask of nodes to be notified about contact
        
        
        leafNode.position = SCNVector3(x: xPosition, y: yPosition, z: zPosition)
//        if noteUIPosition == "fore" || noteUIPosition == "back" {
//            leafNode.eulerAngles = SCNVector3(0, Float.pi / 2, 0)  // fore and back
//        } else {
//            leafNode.eulerAngles = SCNVector3(0, 0, 0)  //left and right
//        }
        
        if noteUIPosition == "fore" {
            leafNode.eulerAngles = SCNVector3(0, Float.pi / 2, 0)  // fore and back
        } else if noteUIPosition == "back" {
            leafNode.eulerAngles = SCNVector3(0, -Float.pi / 2.0, 0)
        } else if noteUIPosition == "left" {
            leafNode.eulerAngles = SCNVector3(0, 0, Float.pi)
        } else {  //right
            leafNode.eulerAngles = SCNVector3(0, 0, 0)  //left and right
        }
        
        
        
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
//        self.neckNode?.geometry?.materials.first?.lightingModel = .constant
//        self.neckNode?.geometry?.firstMaterial?.lightingModel = .lambert
        let omniLightNode1 = SCNNode()
        omniLightNode1.light = SCNLight()
        omniLightNode1.light?.type = SCNLight.LightType.omni
//        omniLightNode1.light?.color = UIColor(white: 1.0, alpha: 1.0)
        omniLightNode1.light?.color = UIColor(white: 1.0,  alpha: 1.0)
//        omniLightNode1.light?.color =  UIColor(red: 1.00, green: 0.358, blue: 0.625, alpha: 0.5)
        omniLightNode1.position = SCNVector3Make(30, 0, 0)  //x大 屏幕外，y大 屏幕上，z大 屏幕左
        omniLightNode1.eulerAngles = SCNVector3Make(0, Float.pi / 2, 0)
        omniLightNode1.light?.categoryBitMask = LightType.onNeck
        omniLightNode1.light?.intensity = 1600
        
        let omniLightNode2 = SCNNode()
        omniLightNode2.light = SCNLight()
        omniLightNode2.light?.type = SCNLight.LightType.omni
        omniLightNode2.light?.color = UIColor(red: 1.0, green: 0.733, blue: 0.273, alpha: 1.0)
//        omniLightNode2.light?.color = UIColor(red: 1.00, green: 0.358, blue: 0.625, alpha: 0.5)
        omniLightNode2.position = SCNVector3(30, 25, -6)
        omniLightNode2.eulerAngles = SCNVector3(x: 0, y: Float.pi / 2, z: 0)
        omniLightNode2.light?.categoryBitMask = LightType.onNeck
        omniLightNode2.light?.intensity = 1000

        let omniLightNode3 = SCNNode()
        omniLightNode3.light = SCNLight()
        omniLightNode3.light?.type = SCNLight.LightType.omni
        omniLightNode3.light?.color = UIColor(red: 1.0, green: 0.399, blue: 0.452, alpha: 1.0)
        omniLightNode3.position = SCNVector3(30, 5, 6)
        omniLightNode3.eulerAngles = SCNVector3Make(0, Float.pi / 2, 0)
        omniLightNode3.light?.categoryBitMask = LightType.onNeck
        omniLightNode3.light?.intensity = 500
        
        let omniLightNode4 = SCNNode()
        omniLightNode4.light = SCNLight()
        omniLightNode4.light?.type = SCNLight.LightType.ambient
        omniLightNode4.light?.color = UIColor(white: 1.0, alpha: 1.0)
//        omniLightNode4.light?.color = UIColor(red: 1.00, green: 0.358, blue: 0.625, alpha: 0.5)
        omniLightNode4.position = SCNVector3(10, 15, 0)
        omniLightNode4.eulerAngles = SCNVector3Make(0, Float.pi / 2, 0)
        omniLightNode4.light?.categoryBitMask = LightType.onNeck
        omniLightNode4.light?.intensity = 5000
        
        let omniLightNode5 = SCNNode()
        omniLightNode5.light = SCNLight()
        omniLightNode5.light?.type = SCNLight.LightType.omni
//        omniLightNode4.light?.color = UIColor(white: 1.0, alpha: 1.0)
        omniLightNode5.light?.color = UIColor(red: 1.00, green: 0.358, blue: 0.625, alpha: 0.5)
        omniLightNode5.position = SCNVector3(10, 15, 0)
        omniLightNode5.eulerAngles = SCNVector3Make(0, Float.pi / 2, 0)
        omniLightNode5.light?.categoryBitMask = LightType.onNeck
        omniLightNode5.light?.intensity = 4000
        
        
        self.rootNode.addChildNode(omniLightNode1)
        self.rootNode.addChildNode(omniLightNode2)
        self.rootNode.addChildNode(omniLightNode3)
//        self.rootNode.addChildNode(omniLightNode4)
        
    }
    
    func addExtraLight() {
        self.backgroundNode?.geometry?.materials.first?.lightingModel = .lambert  //change background material lignting model here.
        let extraLightNode1 = SCNNode()
        extraLightNode1.light = SCNLight()
        extraLightNode1.light?.type = SCNLight.LightType.omni
        extraLightNode1.light?.color = UIColor(red: 0.89, green: 0.97, blue: 0.91, alpha: 1.0)  //green like
        extraLightNode1.light?.intensity = 700
        extraLightNode1.position = SCNVector3(30, -10, 0)
        extraLightNode1.eulerAngles = SCNVector3(0, Float.pi / 2, 0)
        extraLightNode1.light?.categoryBitMask = LightType.onBackground
        self.extraLightNode1 = extraLightNode1
        self.rootNode.addChildNode(extraLightNode1)
        
        let extraLightNode2 = SCNNode()
        extraLightNode2.light = SCNLight()
        extraLightNode2.light?.type = SCNLight.LightType.omni
        extraLightNode2.light?.color = UIColor(red: 0.96, green: 1.0, blue: 0.75, alpha: 1.0) //yellow like
        extraLightNode2.light?.intensity = 700
        extraLightNode2.position = SCNVector3(30, 0, 0)
        extraLightNode2.eulerAngles = SCNVector3(0, Float.pi / 2, 0)
        extraLightNode2.light?.categoryBitMask = LightType.onBackground
        self.extraLightNode2 = extraLightNode2
        self.rootNode.addChildNode(extraLightNode2)
    }
    
    func removeExtraLight() {
        self.backgroundNode?.geometry?.materials.first?.lightingModel = .constant
        self.extraLightNode1?.removeFromParentNode()
        self.extraLightNode2?.removeFromParentNode()
    }
    
    
    
    func checkingAirpods() {
        self.isAirpodsAvailable = false
        func isUsingHeadphones() -> Bool {
            let session = AVAudioSession.sharedInstance()
            
            do {
                let currentRoute = session.currentRoute
                
                for output in currentRoute.outputs {
                    if output.portType == AVAudioSession.Port.headphones || output.portType == AVAudioSession.Port.bluetoothA2DP {
                        return true
                    }
                }
            } catch {
                print("Error setting audio session category: \(error)")
            }
            
            return false
        }
        
        var i = 0
        var timer: Timer?
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            var isUsingHeadphones = isUsingHeadphones()
            if self.motionManager.isDeviceMotionAvailable && isUsingHeadphones {
                self.isAirpodsAvailable = true
                
                print("Airpods are available: ", i)
                i += 1
                timer!.invalidate()
            }
        }
        timer!.fire()
        
        
    }

    func checkingPosition() {
        self.isPositionReady = false
        let readyRange = Double.pi / 32.0
        
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] deviceMotion, error in
            guard let attitude = deviceMotion?.attitude else { return }
            self!.headphoneAnglex = attitude.roll
            self!.headphoneAnglez = attitude.pitch
//            print("new headphonex: ", self!.headphoneAnglex)
//            print("new headphonez: ", self!.headphoneAnglez)
            
            if abs(self!.headphoneAnglex) < readyRange && abs(self!.headphoneAnglez) < readyRange {
                self!.isPositionReady = true
            }
        }
        
        
        
    }
    
    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func stopIphoneMotionUpdates() {
        iphoneMotionManager.stopDeviceMotionUpdates()
    }
    
    
    
    func addNeckRotation() {
        self.isPositionReady = false
        let readyRange = Double.pi / 32.0

        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] deviceMotion, error in
            guard let attitude = deviceMotion?.attitude else { return }
            
            self!.headphoneAnglex = attitude.roll
            self!.headphoneAnglez = attitude.pitch
            
            
            let absx: Float = abs(Float(attitude.roll))
            let absz: Float = abs(Float(attitude.pitch))
            let maxAngle = Float.pi / 6
                        
            
            self?.neckNode?.eulerAngles = SCNVector3(
                x:  (absx > maxAngle ? maxAngle * (-Float(attitude.roll)) / absx : -Float(attitude.roll)) / 2.0 ,
                y: 0,
                z: (absz > maxAngle ? maxAngle * (Float(attitude.pitch)) / absz : Float(attitude.pitch)) / 2.0
            )
            
            if abs(self!.headphoneAnglex) < readyRange && abs(self!.headphoneAnglez) < readyRange {
                self!.isPositionReady = true
            }
        }
        
    }
    
    func addCameraRotation() {
        iphoneMotionManager.startDeviceMotionUpdates(to: .main) { [weak self] deviceMotion, error in
            guard let attitude = deviceMotion?.attitude else {return}
            let absx = abs(Float(attitude.pitch))
            let absy = abs(Float(attitude.yaw))
            let absz = abs(Float(attitude.roll))
            let maxAngle = Float.pi / 12
             //原来角度是 cameraNode.eulerAngles = SCNVector3(x: -0.0, y: +1.60, z: 0.0)
            self?.cameraNode?.eulerAngles = SCNVector3(
                x: 0.0,
                y: 1.60 + (absy > maxAngle ? maxAngle * (Float(attitude.yaw)) / absy : Float(attitude.yaw)) / 2,
                z: 0.0
            )
        }
    }
    
    func stopCameraRotation() {
        self.cameraNode?.eulerAngles = SCNVector3(x: -0.0, y: +1.60, z: 0.0)
        iphoneMotionManager.stopDeviceMotionUpdates()
    }
    
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
//        print("contact begin time: ", Date())
        if ((contact.nodeA.name == "neck" && contact.nodeB.name == "leaf") || (contact.nodeA.name == "leaf" && contact.nodeB.name == "neck")) {
            print("contact begin")
            // get 1 score when "neck" and "leaf" collide
//            self.score += 1   //operate in SwiftUIView
//            self.runEatenEffect()
            
//            physicsWorld.contactDelegate = nil
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { //最快0.25秒进行一次碰撞检测
//                if self.shouldContact {
//                    self.isContacted.toggle()
//                    self.physicsWorld.contactDelegate = self
//
//                    print("延时执行时间：\(Date())")
//                }
//
//            }
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.isContacting = true
            }
//            self.isContacting = true
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.isContacting = false
            }
//            self.isContacting = false
        
        }
        
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        print("contact update")
        if ((contact.nodeA.name == "neck" && contact.nodeB.name == "leaf") || (contact.nodeA.name == "leaf" && contact.nodeB.name == "neck")) && (self.isContacting == false) {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.isContacting = true
            }
            
        }
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        print("contact end")
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.isContacting = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.isContacting = false
        }
//        self.isContacting = false
    }
    
    
}


struct LightType {
    static let onNeck: Int = 0x1 << 1
    static let onBackground: Int = 0x1 << 2
}
