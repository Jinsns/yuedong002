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
    
//    @State var isLeafVisible = false
    

    
    
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
            
        }
//        .onAppear {
//            //set deleget here (in view) or GiraffeScene class init
////            scene.physicsWorld.contactDelegate = scene
//            // 每隔一段时间显示Leaf
//            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
//                isLeafVisible = true
//            }
//        }
        
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
