//
//  NeckSlides.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/28.
//

import Foundation
import SceneKit


class NeckSlide {
    var holder: SCNNode
    var bottomSlide: SCNNode
    var links :[SCNNode] = [SCNNode]()
    
    init() {
        holder = SCNNode()
//        bottomSlide = SCNNode()
        
//        var geometry: SCNGeometry
        var geometry = SCNCylinder(radius: 0.5, height: 0.4)
        geometry.materials.first?.diffuse.contents = UIColor.black
        
        bottomSlide = SCNNode(geometry: geometry)
        bottomSlide.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        bottomSlide.physicsBody?.mass = 5.0
        
        print("bottomSlide position: ", bottomSlide.position)
    }
    
    func getHolder() -> SCNNode {
        return holder
    }
    
    func getbottomSlide() -> SCNNode {
        return self.bottomSlide
    }
    
    
    func getLink(y: Float) -> SCNNode {
        var geometry: SCNGeometry
        var link: SCNNode
        
//        geometry = SCNCylinder(radius: 0.5, height: 0.1)
        geometry = SCNBox(width: 0.4, height: 0.3, length: 0.001, chamferRadius: 0.6)
        geometry.materials.first?.diffuse.contents = UIColor.yellow
        link = SCNNode(geometry: geometry)
//        link.position = SCNVector3(x: 0, y: 0, z: 0)
        print("link position: ", link.position)
        link.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        link.physicsBody?.mass = 1.0
        return link
    }
    
    func clampLinks() {
        var previousLink: SCNNode = self.bottomSlide
        links.forEach { link in
            let origPos: SCNVector3 = previousLink.position
            let newPos: SCNVector3 = link.position
            var dist = (newPos.x - origPos.x) * (newPos.x - origPos.x) + (newPos.y - origPos.y) * (newPos.y - origPos.y) + (newPos.z - origPos.z) * (newPos.z - origPos.z)
            dist = sqrt(dist)
            let midPoint = SCNVector3Make((newPos.x + origPos.x) / 2, (newPos.y + origPos.y) / 2, (newPos.z + origPos.z) / 2)
            
            if (dist > 0.1) {
                print(dist)
                link.position = midPoint
            }
            
            previousLink = link
        }
    }
    
}
