//////
//////  ContentView3.swift
//////  yuedong001
//////
//////  Created by Jzh on 2023/6/8.
//////
////
//import SwiftUI
//import AVFoundation
//
//
//
//let forward1 = [24.0 / 17, 48.0 / 17]
//let backward2 = [(24.0 + 72 * 1) / 17, (48.0 + 72 * 1) / 17]
//let left3 = [(24.0 + 72 * 2) / 17, (48.0 + 72 * 2) / 17]
//let right4 = [(24.0 + 72 * 3) / 17, (48.0 + 72 * 3) / 17]
//let forward5 = [(24.0 + 72 * 4) / 17, (48.0 + 72 * 4) / 17]
//let backward6 = [(24.0 + 72 * 5) / 17, (48.0 + 72 * 5) / 17]
//let left7 = [(24.0 + 72 * 6) / 17, (48.0 + 72 * 6) / 17]
//let right8 = [(24.0 + 72 * 7) / 17, (48.0 + 72 * 7) / 17]
//
//
//var sweatAreaDict:[String:Array] = [
//    "forward1": forward1,
//    "backward2": backward2,
//    "left3": left3,
//    "right4": right4,
//    "forward5": forward5,
//    "backward6": backward6,
//    "left7": left7,
//    "right8": right8
//]
//
//func transToHourMinSec(time: Double) -> String {
//    let allTime: Int = Int(time)
//    var hours = 0
//    var minutes = 0
//    var seconds = 0
//    var hoursText = ""
//    var minutesText = ""
//    var secondsText = ""
//    
//    hours = allTime / 3600
//    hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
//    
//    minutes = allTime % 3600 / 60
//    minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
//    
//    seconds = allTime % 3600 % 60
//    secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
//    
//    return "\(hoursText):\(minutesText):\(secondsText)"
//}
//
//let soundSystem = SoundSystem()
//let bgmSystem = BgmSystem(bgmURL: urlSpatialMoonRiver)
////var playedTime = bgmSystem.audioPlayer?.currentTime
//
//struct ContentView3: View {
//    let motionManager = MotionManager()
////    let soundSystem = SoundSystem()
//
//
//
//    
//    @State var playState = false
//    @State var curTime = 0.0
//    
//    @State var topBackward = false
//    @State var topForward = false
//    @State var antiClock = false
//    @State var clockWise = false
//    @State var matchSweat = false
//    @State var motionSwitch = false
//    
//
//    
//
//    
//
//
//
//    var body: some View {
//
//        TimelineView(.animation){ timeline in
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text(playState ? "Playing" : "Stop")
//                .onChange(of: playState) {newPlayState in
//                    print(sweatAreaDict)
//                    
//                    if playState {
//                        bgmSystem.play()
//                    } else {
//                        bgmSystem.stop()
//                    }
//                    
//                }
//            Button(action:{
//                playState.toggle()
//            }, label: {
//                Text(playState ? "press to stop" : "press to play")
//            })
//            Text(transToHourMinSec(time: curTime))
//
//            
//            
//            
//            MotionStateView(motionManager: motionManager, topBackward: $topBackward, topForward: $topForward, antiClock: $antiClock, clockWise: $clockWise)
//                .onChange(of: curTime) { newCurTime in
////                    print(newCurTime)
//                    
//                    if motionManager.pitch < -3.14 / 6 {
//                        topForward = true
//                        if (sweatAreaDict["forward1"]?[0] ?? 0.0)...(sweatAreaDict["forward1"]?[1] ?? 0.1) ~= newCurTime
//                            || (sweatAreaDict["forward5"]?[0] ?? 0.0)...(sweatAreaDict["forward5"]?[1] ?? 0.1) ~= newCurTime {
//                            print("match forward at \(newCurTime)")
//                            matchSweat = true
//                        } else {
//                            matchSweat = false
//                            motionSwitch = false
//                        }
//                        
//                    } else {
//                        topForward = false
////                        soundSystem.stop()
//                    }
//                    if motionManager.pitch > 3.14 / 6 {
//                        topBackward = true
//
//                        if (sweatAreaDict["backward2"]?[0] ?? 0.0)...(sweatAreaDict["backward2"]?[1] ?? 0.1) ~= newCurTime
//                            || (sweatAreaDict["backward6"]?[0] ?? 0.0)...(sweatAreaDict["backward6"]?[1] ?? 0.1) ~= newCurTime {
//                            print("match backward at \(newCurTime)")
//                            matchSweat = true
//                        } else {
//                            matchSweat = false
//                            motionSwitch = false
//                        }
//                    } else {
//                        topBackward = false
////                        soundSystem.stop()
//                    }
//                    if motionManager.roll < -3.14 / 6 {
//                        antiClock = true
//                        if (sweatAreaDict["left3"]?[0] ?? 0.0)...(sweatAreaDict["left3"]?[1] ?? 0.1) ~= newCurTime
//                            || (sweatAreaDict["left7"]?[0] ?? 0.0)...(sweatAreaDict["left7"]?[1] ?? 0.1) ~= newCurTime {
//                            print("match left at \(newCurTime)")
//                            matchSweat = true
//                        } else {
//                            matchSweat = false
//                            motionSwitch = false
//                        }
//                    } else {
//                        antiClock = false
////                        soundSystem.stop()
//                    }
//                    if motionManager.roll > 3.14 / 6 {
//                        clockWise = true
//                        if (sweatAreaDict["right4"]?[0] ?? 0.0)...(sweatAreaDict["right4"]?[1] ?? 0.1) ~= newCurTime
//                            || (sweatAreaDict["right8"]?[0] ?? 0.0)...(sweatAreaDict["right8"]?[1] ?? 0.1) ~= newCurTime {
//                            print("match right at \(newCurTime)")
//                            matchSweat = true
//                            
//                        } else {
//                            matchSweat = false
//                            motionSwitch = false
//                        }
//                        
//                    } else {
//                        clockWise = false
////                        soundSystem.stop()
//                    }
//                    if topBackward || topForward || antiClock || clockWise {
//                        motionSwitch = true
//                    } else {
//                        motionSwitch = false
//                    }
//                    
//                    
//                
//                
//            }
//                
//                
//        }.onAppear{
//            print("load music info from json")
//            var musicInfo = parseMusicInfo(musicName: "MoonRiver")!
//
//            var bpm = musicInfo.bpm
//            var timeSignature = musicInfo.timeSignature
//            var secondPerBeat = musicInfo.secondPerBeat
//            var beats = musicInfo.beats
//            
//            for var beat in beats {
//                var moment = beat.moment
//                beat.perfectArea = [moment - 0.5 * secondPerBeat, moment + 0.5 * secondPerBeat]
//                beat.greatArea = [moment - 1.0 * secondPerBeat, moment + 1.0 * secondPerBeat]
//                beat.goodArea = [moment - 1.5 * secondPerBeat, moment + 1.5 * secondPerBeat]
//                beat.badArea = [moment - 2.0 * secondPerBeat, moment + 2.0 * secondPerBeat]
//                
//            }
//            
//            
//            
//            print("initialize curTime with bgm audioplayer currentTime")
//            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (_) in
//                            if playState {
//                                curTime = (bgmSystem.audioPlayer?.currentTime ?? 0)
////                                print(curTime)
//                            }
//                        }
//        }
//        .onChange(of: matchSweat){ newMatchSweat in
//            if newMatchSweat {
//                soundSystem.play(soundUrl: urlC)
//                motionSwitch = false
//            }else {
//                soundSystem.stop()
//            }
//            
//        }
//        .onDisappear(){
//            bgmSystem.stop()
//        }
//        .navigationTitle("Relax Mode")
//    }
//}
//
//
//struct ContentView3_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView3()
//    }
//}
//
