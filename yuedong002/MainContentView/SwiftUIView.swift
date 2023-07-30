//
//  SwiftUIView.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/23.
//

import SwiftUI
import SceneKit

struct SwiftUIView: View {
    
    @State var isInHomePage = true
    @State var isGaming = false
    
    @ObservedObject var scene = GiraffeScene()
    
    private let cameraNode = createCameraNode()
    
    @ObservedObject var bgmSystem = BgmSystem(bgmURL: urlSpatialMoonRiver)
    
    //show the progress of bgm
    @State private var trimEnd: CGFloat = 0.0
    
    @State var isShowPause = false
    @State var isShowCountScoreView = false
    
    
    
    var body: some View {
        ZStack{
            
            SceneView(scene: scene, pointOfView: cameraNode)
                .ignoresSafeArea()
            
            
            if isInHomePage {
                HomePageView()
            }
            
            
            ZStack {  //gaming view
                
                Button {
                    print("pressed pause button")
                    isShowPause = true
                    
                } label: {
                    Image("pauseCircle")
                        .resizable()
                }
                .frame(width: 48, height: 48)
                .offset(x: 160, y: -330)
                
                if isShowPause {
                    Color.black.opacity(0.1)  //darken background of PauseAlertView
                        .ignoresSafeArea()
                    PauseAlertView(isShowPause: $isShowPause, isShowCountScoreView: $isShowCountScoreView, leafNum: $scene.score)
                }
                

                
                
                
                Image("ruling")   //background
                    .resizable()
                    .padding(.all, 10)  //padding must be above frame
                    .frame(width: 150, height: 150)
                    .offset(x: 0, y: -280)
                    .opacity(0.2)
                    .colorMultiply(Color.black)
                    .colorMultiply(Color.gray)
                
                Image("ruling")   //front fade-out
                    .resizable()
                    .padding(.all, 10)  //padding must be above frame
                    .frame(width: 150, height: 150)
//                    .padding(.all, 10)
                    .opacity(1.0)
                    .offset(x: 0, y: -280)
//                    .colorMultiply(Color.gray)
                    .mask {
                        Circle()
                            .trim(from: 0.0, to: trimEnd) //trimEnd = 1 means 360 degree
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .foregroundColor(.gray)
                            .frame(width: 120, height: 120)
                            .padding(.all, 10)
                            .offset(x: 280, y: 0)    //-90 degree时，x=280, y=0
                            .opacity(0.6)
                            .rotationEffect(.degrees(-90))
                            .scaleEffect(x: -1, y: 1) //镜像反转 （水平翻转）
                            
                            .onChange(of: bgmSystem.currentTime) { newValue in
                                print("newValue of curtime", newValue)
                                trimEnd = (bgmSystem.duration - newValue) / bgmSystem.duration
                            }
                    }
                Text("\(scene.score)")
                    .frame(width: 150, height: 150)
                    .padding(.all, 10)
                    .offset(x: 0, y: -270)
                    .foregroundColor(Color(hex: "68A128"))
//                    .onChange(of: scene.score) { newScore in
//                        //eat the first leaf to start bgm, start gaming
//                        if newScore == 1 {
//                            print("newScore == 1 : ", newScore)
//                            isGaming = true
//                            bgmSystem.play()
//                            print("music playing has a duration of ", bgmSystem.duration)
//                        }
//                    }
                    
                Image("scorePan")
                    .resizable()
                    .padding(.all, 10)
                    .frame(width: 150, height: 150)
                    .offset(x: 0, y: -280)
                
            } // GamingView: zstack of ruling and circle
            .onChange(of: scene.score) { newScore in
                if newScore == 1 {                       //game starts
                    trimEnd = 1.0

                    bgmSystem.play()
//                    isGaming = true
                    isInHomePage = false
                }
                
            }
            .onChange(of: isShowPause, perform: { newValue in  //when game pauses
                if newValue == true { //show pause
                    bgmSystem.pause()
//                    isGaming = false
                    
                    
                } else {  //resume from pause
                    bgmSystem.play()
//                    isGaming = true
                }
            })
            .onChange(of: bgmSystem.currentTime) { newValue in
                if newValue == 0.0 && scene.score >= 1 {   //when game ends
                    //bgmSystem.stop() will let bgmSystem.currentTime turns to 0.0
                    //and if scene.score >= 1 means game once started
                    isShowCountScoreView = true
//                    isGaming = false
                    
                }
            }
            .fullScreenCover(isPresented: $isShowCountScoreView, content: {
                CountScoreView(scene: scene, isInHomePage: $isInHomePage)
                    .onAppear {
                        bgmSystem.stop()
//                        isGaming = false
                    }
            })
            .opacity(!isInHomePage ? 1.0 : 0.0)
            
            
            

            
        }
        
        
        
        
    }
    
    static func createCameraNode() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        return cameraNode
    }
}
                         


struct SceneKitView: UIViewRepresentable {
    let scene: SCNScene

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.scene = scene
        view.allowsCameraControl = true
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}






struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

