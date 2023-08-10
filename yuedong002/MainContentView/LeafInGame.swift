//
//  LeafInGame.swift
//  yuedong002
//
//  Created by Jzh on 2023/8/10.
//

import SwiftUI
import SceneKit

//struct LeafInGame: View {
//    var scene = GiraffeScene()
//    var body: some View {
//        ZStack {
//            SceneView(scene: scene)
//                .ignoresSafeArea()
//            leaf1(leafPosition: .constant("fore"), leafLevel: .constant(1))
//        }
//
//    }
//}
//
//struct LeafInGame_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        LeafInGame()
//    }
//}


struct leaf1: View {
    
    @State var trimEnd: CGFloat = 0.3
    @Binding var leafPosition: String
    @Binding var leafLevel: Int
    
    var body: some View {
        ZStack {
//            Text("isLeafAdded: \(String(isLeafAdded)) ")
            Image("ruling")
                .resizable()
                .frame(width: 100, height: 100)
                .reverseMask {
                    Circle()
                        .trim(from: 0.0, to: trimEnd)
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                        .frame(width: 90, height: 90)
                        .rotationEffect(.degrees(-87))
                }
            
//            Circle()
//                .trim(from: 0.0, to: trimEnd)
//                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .butt))
//                .frame(width: 90, height: 90)
//                .rotationEffect(.degrees(-87))
                
            Image("leaf")
                .resizable()
                .frame(width: 74, height: 74)
                .colorMultiply(.yellow)
        }
        .scaleEffect(
            (leafPosition == "left" || leafPosition == "right") ? 1.2 :
                        ( (leafPosition == "fore") ? 1.4
                          : 0.8 )
        )
//        .scaleEffect(1.2)  //left and right
//        .scaleEffect(1.4)  //forward
//        .scaleEffect(0.8)  //backward
        .offset(
            x: (leafPosition == "left") ? -120 : ((leafPosition == "right") ? 120 : 0),
                y: (leafPosition == "fore") ? 130 : ((leafPosition == "back") ? -135 : 0)
        )
//        .offset(
//            {
//                let offset: CGSize
//                switch leafPosition {
//                    case "left":
//                        offset = CGSize(width: -120, height: 0)
//                    case "right":
//                        offset = CGSize(width: 120, height: 0)
//                    case "fore":
//                        offset = CGSize(width: 0, height: 130)
//                    default:
//                        offset = CGSize(width: 0, height: -135)
//                }
//                return offset
//            }()
//        )
        
//        CGSize
//        .offset(x: -120, y: 0)  //left
//        .offset(x: 120, y: 0)   //right
//        .offset(x: 0, y: 130)   //forward
//        .offset(x:0, y: -135)     //backward
        
        .onAppear() {
            trimEnd = 0.0
            var timer: Timer?
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                withAnimation {
                    trimEnd += 1.0 / 400.0 // You can adjust the increment as needed
                    if trimEnd > 1.0 {
                        timer!.invalidate() // Stop the timer when trimEnd reaches 1.0
                    }
                }
            }
            timer!.fire() // Start the timer
        }
        .onDisappear() {
            trimEnd = 0.0
        }
        
        
        
    }
}
