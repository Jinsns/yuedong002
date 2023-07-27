//
//  SwiftUIView.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/23.
//

import SwiftUI
import SceneKit

struct SwiftUIView: View {
    
    @ObservedObject private var scene = GiraffeScene()
    private let cameraNode = createCameraNode()
    
    @ObservedObject var bgmSystem = BgmSystem(bgmURL: urlSpatialMoonRiver)
    
    //show the progress of bgm
    @State private var trimEnd: CGFloat = 0.0
    
    @State var showCountScoreView = false
    
    
    
    var body: some View {
        ZStack{
            
            SceneView(scene: scene, pointOfView: cameraNode)
                .ignoresSafeArea()
            
            ZStack {
                Image("ruling")
                    .resizable()
                    .padding(.all, 10)
                    .frame(width: 150, height: 150)
                    .padding(.all, 10)
                    .opacity(0.9)
                    .offset(x: 0, y: -280)
                    .colorMultiply(Color.gray)
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
                            .onReceive(scene.$score) { newScore in
                                
                                if newScore == 1 {
                                    trimEnd = 1.0
                                    //                                    animationDuration = bgmSystem.duration
                                }
                                
                            }
                            .onChange(of: bgmSystem.currentTime) { newValue in
                                trimEnd = (bgmSystem.duration - newValue) / bgmSystem.duration
                            }
                    }
            } // zstack of ruling and circle
            
            
            
            
            
            
            Gauge(value: (bgmSystem.currentTime), in: 0.0...bgmSystem.audioPlayer!.duration) {
                Text("\(scene.score)")
                //              Text("\(Int(bgmSystem.currentTime))")
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .frame(width: 250, height: 250)
            .padding(.all, 10)
            .offset(x: 0, y: -300)
            .frame(width:300, height: 300)
            .onChange(of: scene.score) { newScore in
                if newScore == 1 {   //eat the first leaf to start bgm, start gaming
                    print("newScore == 1 : ", newScore)
                    bgmSystem.play()
                    print("music playing has a duration of ", bgmSystem.duration)
                }
            }
            
            
            
            
            
            
        }
        .onChange(of: bgmSystem.currentTime) { newValue in
            if newValue == 0.0 && scene.score >= 1 {
                //bgmSystem.stop() will let bgmSystem.currentTime turns to 0.0
                //and if scene.score >= 1 means game once started
                showCountScoreView = true
                
            }
        }
        .fullScreenCover(isPresented: $showCountScoreView, content: {
            CountScoreView()
        })
        
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
