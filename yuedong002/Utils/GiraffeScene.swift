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

class GiraffeScene: SCNScene, SCNPhysicsContactDelegate, ObservableObject {
    
    private let motionManager = CMMotionManager()
    
    private var planetNode: SCNNode?
    private var neckNode: SCNNode?
    private var leafNode: SCNNode?
    
    @Published var score: Int = 0
//    var shouldAddLeafNode = false
    
    var leafXPosition = Float(2.0)
    var leafYPosition = Float(0.0)
    var leafZPosition = Float(0.0)
    
//    private var audioEngine = AVAudioEngine()
//    private var leafAudioPlayer = AVAudioPlayerNode()
//    private var collisionAudioPlayer = AVAudioPlayerNode()
    
    
    
    override init() {
        super.init()
//        setupAudioEngine()
        
        
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
        let leafGeometry = SCNBox(width: 2, height: 1, length:1, chamferRadius: 0.2)
        leafGeometry.materials = [leafMaterial]
        
        let leafNode = SCNNode(geometry: leafGeometry)
        leafNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        leafNode.physicsBody?.categoryBitMask = 2 // Set a unique bitmask for the "leaf" node
        leafNode.physicsBody?.contactTestBitMask = 1  // Set the bitmask of nodes to be notified about contact
        
        leafNode.position = SCNVector3(x: xPosition, y: yPosition, z: zPosition)
        leafNode.name = "leaf"
        
        
        let leafAudioSource = SCNAudioSource(fileNamed: "pianoD.mp3")!
        leafAudioSource.isPositional = true // Enable 3D spatialization
        leafAudioSource.shouldStream = false // Use streaming for longer audio files
        leafNode.addAudioPlayer(SCNAudioPlayer(source: leafAudioSource))
        //播放
        leafNode.runAction(SCNAction.playAudio(leafAudioSource, waitForCompletion: false))
        
        
        self.rootNode.addChildNode(leafNode)
        self.leafNode = leafNode
        
//        playLeafAudio(at: leafNode.position)
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
            
//            self.shouldAddLeafNode = true
            self.leafXPosition = -self.leafXPosition
            self.leafYPosition = -self.leafYPosition
            self.addLeafNode(xPosition: self.leafXPosition, yPosition: self.leafYPosition, zPosition: self.leafZPosition)
            self.leafNode?.opacity = 0.0 // Set the initial opacity to 0
            self.leafNode?.runAction(SCNAction.fadeIn(duration: 0.5))
            
        } else if (contact.nodeA.name == "leaf" && contact.nodeB.name == "neck") {
            print("contact 2")
//            self.playCollisionAudio(at: contact.nodeA.position)
            self.score += 1
            print("score: \(self.score)")
            
            contact.nodeA.removeFromParentNode()  //remove leafnode
            
//            self.shouldAddLeafNode = true
            self.leafXPosition = -self.leafXPosition
            self.leafYPosition = -self.leafYPosition
            self.addLeafNode(xPosition: self.leafXPosition, yPosition: self.leafYPosition, zPosition: self.leafZPosition)
            self.leafNode?.opacity = 0.0 // Set the initial opacity to 0
            self.leafNode?.runAction(SCNAction.fadeIn(duration: 0.5))
            
        }
        
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
    
//    private func setupAudioEngine() {
//        let audioSession = AVAudioSession.sharedInstance()
//
//        do {
//            try audioSession.setCategory(.playback, mode: .default)
//            try audioSession.setActive(true)
//
//            // Load audio files and prepare player nodes
//            guard let leafAudioFile = Bundle.main.url(forResource: "pianoD", withExtension: "mp3"),
//                  let collisionAudioFile = Bundle.main.url(forResource: "pianoC2", withExtension: "mp3") else {
//                fatalError("Could not find audio files.")
//            }
//            // Attach player nodes to the audio engine
//            self.audioEngine.attach(leafAudioPlayer)
//            self.audioEngine.attach(collisionAudioPlayer)
//
//            //Connect the playernode to engine's outputNode
//            self.audioEngine.connect(leafAudioPlayer, to: audioEngine.outputNode, format: nil)
//            self.audioEngine.connect(collisionAudioPlayer, to: audioEngine.outputNode, format: nil)
//
//            // Connect the AVAudioEngine to the output
////            audioEngine.connect(audioEngine.mainMixerNode, to: audioEngine.outputNode, format: nil)
//
//            let leafAudio = try AVAudioFile(forReading: leafAudioFile)
//            let collisionAudio = try AVAudioFile(forReading: collisionAudioFile)
//
//            self.leafAudioPlayer.scheduleFile(leafAudio, at: nil)
//            self.collisionAudioPlayer.scheduleFile(collisionAudio, at: nil)
//
//
//
//            // Start the audio engine
//            try audioEngine.start()
//            print("engine started")
//        } catch {
//            print("Error setting up audio engine: \(error.localizedDescription)")
//        }
//    }
    
//    private func playLeafAudio(at position: SCNVector3) {
//        // Set the position of the AVAudioPlayerNode to match the position of the leaf node
//        self.leafAudioPlayer.position = AVAudio3DPoint(x: Float(position.x), y: Float(position.y), z: Float(position.z))
//        self.leafAudioPlayer.play()
//    }
//
//    private func playCollisionAudio(at position: SCNVector3) {
//        // Set the position of the AVAudioPlayerNode to match the position of the neck node
//        self.collisionAudioPlayer.position = AVAudio3DPoint(x: Float(position.x), y: Float(position.y), z: Float(position.z))
//        self.collisionAudioPlayer.play()
//    }

    
}
