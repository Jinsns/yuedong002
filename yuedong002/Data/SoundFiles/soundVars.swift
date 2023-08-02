//
//  soundVars.swift
//  yuedong002
//
//  Created by Jzh on 2023/6/24.
//

import Foundation

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
