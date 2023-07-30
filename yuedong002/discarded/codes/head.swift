//
//  head.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/28.
//

import Foundation
import SceneKit


class Head {
    var head: SCNNode
    
    func getHead() -> SCNNode {
        return head
    }
    
    init() {
        var geometry: SCNGeometry
        geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.1)
        geometry.materials.first?.diffuse.contents = UIColor.blue
        head = SCNNode(geometry: geometry)
        head.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        head.physicsBody?.mass = 5.0
        head.physicsBody?.friction = 0.5
        print("head position: ", head.position)
    }
    
    func hold() {
        head.position = SCNVector3(x: 0, y: -3, z: 0)
    }
}
