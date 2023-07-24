//
//  GiraffeScene.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/23.
//

import Foundation
import SceneKit
import CoreMotion

class GiraffeScene: SCNScene {
    
    private let motionManager = CMMotionManager()
    
    private var planetNode: SCNNode?
    private var neckNode: SCNNode?
    
    
    
    
    override init() {
        super.init()
        addBackground()
//        addPlanetNode()
        addNeckNode() // 添加脖子节点
        configureCamera()
        addOmniLight()
        
        addPlanetRotation()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCamera() {
        self.rootNode.position = SCNVector3(x: 0.0, y: 0, z: -8)
    }
    
    func addBackground() {
        background.contents = UIColor.black
    }
    
    func addPlanetNode() {
        let planetMaterial = SCNMaterial()
        planetMaterial.diffuse.contents = UIImage(named: "Ellipse")
           
        let planetGeometry = SCNSphere(radius: 1)
        planetGeometry.materials = [planetMaterial]

        let planetNode = SCNNode(geometry: planetGeometry)

        planetNode.position = SCNVector3(0, 0, 0)
        self.rootNode.addChildNode(planetNode)
        self.planetNode = planetNode
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
        print("......")
        print("simdp \(neckNode.simdPosition)")
        print("p \(neckNode.position)")

        // 根据需要对脖子模型进行缩放和位置调整
        neckNode.scale = SCNVector3(0.2, 0.2, 1.0)
        neckNode.position = SCNVector3(0, 0, 0) // 设置位置，根据需要调整
        
        print("simdp \(neckNode.simdPosition)")
        print("p \(neckNode.position)")

        self.rootNode.addChildNode(neckNode)
        self.neckNode = neckNode
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
                x: Float(attitude.pitch),
                y: Float(attitude.roll),
                z: Float(attitude.yaw)
            )
        }
    }
    
    
    
}
