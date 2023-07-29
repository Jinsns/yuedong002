////
////  GamingView.swift
////  yuedong002
////
////  Created by Jzh on 2023/7/29.
////
//
//import SwiftUI
//
//struct GamingView: View {
//    
//    @ObservedObject private var scene = GiraffeScene()
//    @ObservedObject var bgmSystem = BgmSystem(bgmURL: urlSpatialMoonRiver)
//    
//    
//    @Binding var showPause: Bool
//    @Binding var showCountScoreView: Bool
//    @State private var trimEnd: CGFloat = 0.0
//    
//    
//    var body: some View {
//        ZStack {
//            
//            Button {
//                print("pressed pause button")
//                showPause = true
//            } label: {
//                Image("pauseCircle")
//                    .resizable()
//            }
//            .frame(width: 48, height: 48)
//            .offset(x: 160, y: -330)
//            
//            if showPause {
//                Color.black.opacity(0.1)
//                PauseAlertView(isPresented: $showPause, leafNum: $scene.score)
//            }
//            
//
//            
//            
//            
//            Image("ruling")   //background
//                .resizable()
//                .padding(.all, 10)  //padding must be above frame
//                .frame(width: 150, height: 150)
//                .offset(x: 0, y: -280)
//                .opacity(0.2)
//                .colorMultiply(Color.black)
//                .colorMultiply(Color.gray)
//            
//            Image("ruling")   //front fade-out
//                .resizable()
//                .padding(.all, 10)  //padding must be above frame
//                .frame(width: 150, height: 150)
////                    .padding(.all, 10)
//                .opacity(1.0)
//                .offset(x: 0, y: -280)
////                    .colorMultiply(Color.gray)
//                .mask {
//                    Circle()
//                        .trim(from: 0.0, to: trimEnd) //trimEnd = 1 means 360 degree
//                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
//                        .foregroundColor(.gray)
//                        .frame(width: 120, height: 120)
//                        .padding(.all, 10)
//                        .offset(x: 280, y: 0)    //-90 degree时，x=280, y=0
//                        .opacity(0.6)
//                        .rotationEffect(.degrees(-90))
//                        .scaleEffect(x: -1, y: 1) //镜像反转 （水平翻转）
//                        .onReceive(scene.$score) { newScore in
//                            
//                            if newScore == 1 {
//                                trimEnd = 1.0
//                                //                                    animationDuration = bgmSystem.duration
//                            }
//                            
//                        }
//                        .onChange(of: bgmSystem.currentTime) { newValue in
//                            trimEnd = (bgmSystem.duration - newValue) / bgmSystem.duration
//                        }
//                }
//            Text("\(scene.score)")
//                .frame(width: 150, height: 150)
//                .padding(.all, 10)
//                .offset(x: 0, y: -270)
//                .foregroundColor(Color(hex: "68A128"))
//                .onChange(of: scene.score) { newScore in
//                    if newScore == 1 {   //eat the first leaf to start bgm, start gaming
//                        print("newScore == 1 : ", newScore)
//                        bgmSystem.play()
//                        print("music playing has a duration of ", bgmSystem.duration)
//                    }
//                }
//                
//            Image("scorePan")
//                .resizable()
//                .padding(.all, 10)
//                .frame(width: 150, height: 150)
//                .offset(x: 0, y: -280)
//            
//        } // zstack of ruling and circle
//        .onChange(of: bgmSystem.currentTime) { newValue in
//            if newValue == 0.0 && scene.score >= 1 {
//                //bgmSystem.stop() will let bgmSystem.currentTime turns to 0.0
//                //and if scene.score >= 1 means game once started
//                showCountScoreView = true
//                
//            }
//        }
//        .fullScreenCover(isPresented: $showCountScoreView, content: {
//            CountScoreView(finalScore: $scene.score)
//        })
//        
//    }
//}
//
////struct GamingView_Previews: PreviewProvider {
////    static var previews: some View {
////        GamingView(scene: GiraffeScene(), showPause: .constant(false), showCountScoreView: .constant(false))
////    }
////}
//
