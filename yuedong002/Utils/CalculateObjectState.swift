//
//  CalculateObjectState.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/31.
//

import Foundation
import SceneKit


func solveHeadPosition(neckLength: Float, pitch: Float, roll: Float) -> (x: Float, y: Float, z: Float, theta: Float, phi: Float) {
    //a = pitch, b = roll
    //sin(theta) = sqrt((sin a)^2 + (sin b)^2), so
    var theta = asin( sqrt( pow(sin(pitch), 2) + pow(sin(roll), 2)) )
    
    //tan phi = sin b / sin a, so
    var phi = atan( sin(roll) / sin(pitch) )
    
    var x = neckLength * sin(theta) * cos(phi)
    var y = neckLength * sin(theta) * sin(phi)
    var z = neckLength * cos(theta)
    
    return (x, y, z, theta, phi)
}

struct slide {
    
    //position
    var x: Float
    var y: Float
    var z: Float
    var theta: Float
    var phi: Float
    
    //rotation
    var rotatePitch: Float
    var rotateRoll: Float
}



func solveNeckSlides(SlidesNum: Int, theta: Float, phi: Float, headPosition: SCNVector3, headHeight: Float, neckPosition: SCNVector3, neckHeight: Float ) -> [slide] {
    var slides = [slide]()
    let countSlides = SlidesNum
    
    
    //theta1 + theta2 + ... + theta10 = theta
    let atheta = Float(theta / Float(countSlides) ) //average theta
    let alen = (headPosition.y - neckPosition.y) /  Float(countSlides)  //每个slide占据的L （自身长度+占据的空气长度）
    print("alen: ", alen)
    
    
    //the first slide's position
    var ax = Float(neckPosition.x)
    var ay = Float(neckPosition.y) + Float(neckHeight / 2.0)
    var az = Float(neckPosition.z)
    
    var aSlide = slide(x: ax, y: ay, z: az, theta: atheta, phi: phi, rotatePitch: 0, rotateRoll: 0)
    slides.append(aSlide)  //append the first slide
    
    var len = [Float]()  //每个slide的极长，原点是neck顶部
    len.append(alen)
    print("len: ", len)
    
    
    
    var i = 1
    while i < countSlides {  //0 ~ 9
        print("len[0]: ", len[0])
        print("i: ", i)
        len[i] = len[i-1] * cos(atheta) + alen * cos(atheta)
        var coordinates = solveHeadPosition(neckLength: len[i], pitch: atheta, roll: phi)
        aSlide = slide(x: coordinates.x, y: coordinates.y, z: coordinates.z, theta: atheta, phi: phi, rotatePitch: 0, rotateRoll: 0)
        slides.append(aSlide)
        i += 1
    }
    
    return slides  //return an array
    
}
