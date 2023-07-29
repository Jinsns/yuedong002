//
//  Floor.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/28.
//

import Foundation
import SceneKit


class Floor {
    
    var floor: SCNNode
    
    func getFloor() -> SCNNode {
        return floor
    }
    
    init() {
        var geometry:SCNGeometry
        geometry = SCNFloor()
        geometry.materials.first?.diffuse.contents = UIColor.brown
        floor = SCNNode(geometry: geometry)
        floor.position = SCNVector3(x: 0, y: -1, z: 0)
        
        let floorShape = SCNPhysicsShape(geometry: geometry, options: nil)
        let floorBody = SCNPhysicsBody(type: .static, shape: floorShape)
        floor.physicsBody = floorBody
    }
}
