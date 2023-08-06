//
//  soundVars.swift
//  yuedong002
//
//  Created by Jzh on 2023/6/24.
//

import Foundation
import SceneKit

let pathC = Bundle.main.path(forResource: "pianoC", ofType: "mp3")!
let pathD = Bundle.main.path(forResource: "pianoD", ofType: "mp3")!
let pathE = Bundle.main.path(forResource: "pianoE", ofType: "mp3")!
let pathF = Bundle.main.path(forResource: "pianoF", ofType: "mp3")!
let pathSpatialMoonRiver = Bundle.main.path(forResource: "0614spatial_moonriver", ofType: "mp3")!


let urlC = URL(fileURLWithPath: pathC)
let urlD = URL(fileURLWithPath: pathD)
let urlE = URL(fileURLWithPath: pathE)
let urlF = URL(fileURLWithPath: pathF)
let urlSpatialMoonRiver = URL(fileURLWithPath: pathSpatialMoonRiver)
let homePageBgmURL = Bundle.main.url(forResource: "BGM_HomepageAndCamera", withExtension: "mp3")
let urlCaterpillarsFly = Bundle.main.url(forResource: "虫儿飞", withExtension: "mp3")


struct Note {
    let startTime: Double
    let endTime: Double
    let leafPosition: SCNVector3
    let isTenuto: Bool
}



//var notes = [note]()
//notes.append(note(startTime: 5.0, endTime: 15.0, leafPosition: SCNVector3(x: -1.5, y: -2, z: 1), isTenuto: true))
//notes.append(note(startTime: 20.0, endTime: 25.0, leafPosition: SCNVector3(x: -1.5, y: -2, z: 1), isTenuto: true))
//notes.append(note(startTime: 5.0, endTime: 15.0, leafPosition: SCNVector3(x: -1.5, y: -2, z: 1), isTenuto: true))

