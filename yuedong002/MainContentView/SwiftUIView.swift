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
//    @State var score = 0
    
    private let cameraNode = createCameraNode()
    
    @State var isLeafVisible = false
    

    
    
    var body: some View {
        ZStack{
            
            
            SceneView(scene: scene, pointOfView: cameraNode)
                .ignoresSafeArea()
            
            Text("当前得分\n       \(scene.score)")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .background(
                        Circle()
                            .foregroundColor(.green)
                            .opacity(0.9)
                            .frame(width: 150, height: 150)
                            .shadow(color: Color.white.opacity(0.3), radius: 5, x: 10, y: 5)
                    )
                    .padding(.all, 10)
                    .offset(x: 0, y: -300)
            
            
            if isLeafVisible {
                LeafView(isLeafVisible: $isLeafVisible)
            }
            
        }
        .onAppear {
            //set deleget here (in view) or GiraffeScene class init
//            scene.physicsWorld.contactDelegate = scene
            // 每隔一段时间显示Leaf
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                isLeafVisible = true
            }
        }
//        .onReceive(scene.$score) { updatedScore in
//            // Update the view when the scene's @Published properties change
//            score = updatedScore
//        }

        
    }
    
    static func createCameraNode() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        return cameraNode
    }
}

struct LeafPosition {
    let xOffset: CGFloat
    let yOffset: CGFloat
}

struct LeafView: View {
    @ObservedObject var midiPlaySystem = MidiPlaySystem()

    @State var xOffset = 0.0
    @State var yOffset = 0.0
    
    @Binding var isLeafVisible: Bool

    //possible position of appearance
    let leafPositions: [LeafPosition] = [
        LeafPosition(xOffset: -150, yOffset: 200),
        LeafPosition(xOffset: 0, yOffset: 200),
        LeafPosition(xOffset: 150, yOffset: 200),
        
        LeafPosition(xOffset: -150, yOffset: 0),
//        LeafPosition(xOffset: 0, yOffset: 0),
        LeafPosition(xOffset: 150, yOffset: 0),
        
        LeafPosition(xOffset: -150, yOffset: -200),
        LeafPosition(xOffset: 0, yOffset: -200),
        LeafPosition(xOffset: 150, yOffset: -200)
    ]

    var body: some View {
        Image("leaf")
            .resizable()
            .frame(width: 130, height: 130)
            .offset(x: xOffset, y: yOffset)
            .shadow(color: Color.white.opacity(0.3), radius: 5, x: 10, y: 5)
            .onAppear {
                // 设置随机坐标
                if let leafPosition = leafPositions.randomElement() {
                    // 使用随机取出的 CGPoint 坐标
                    xOffset = leafPosition.xOffset
                    yOffset = leafPosition.yOffset
                    
                    print("随机取出的 CGPoint: \(leafPosition)")
                    
                } else {
                    print("数组为空，无法取出随机元素")
                }
                
                // 播放音符
                var velocity = UInt8(150)     // to correct with motion
                midiPlaySystem.playNoteWithPitch(pitch: 71, velocity: velocity)

            }
            .onTapGesture {
                // 点击动物后使其消失
                isLeafVisible = false
            }
            
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
