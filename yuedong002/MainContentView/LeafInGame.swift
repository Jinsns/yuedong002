//
//  LeafInGame.swift
//  yuedong002
//
//  Created by Jzh on 2023/8/10.
//

import SwiftUI
import SceneKit

struct LeafInGame: View {
    var scene = GiraffeScene()
    var body: some View {
        ZStack {
//            SceneView(scene: scene)
//                .ignoresSafeArea()
//            leaf1(leafPosition: .constant("fore"), leafLevel: .constant(1))
            Rectangle()
        }

    }
}

struct LeafInGame_Previews: PreviewProvider {

    static var previews: some View {

//        LeafInGame()
        leaf1(leafPosition: .constant("left"), leafLevel: .constant(3), isTenuto: .constant(true))
    }
}


struct leaf1: View {
    
    @State var trimEnd: CGFloat = 0.3
    @Binding var leafPosition: String
    @Binding var leafLevel: Int
    @Binding var isTenuto: Bool
    
    var body: some View {
        ZStack {
//            Text("isLeafAdded: \(String(isLeafAdded)) ")
            if isTenuto {
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

            }
                        
//            Circle()
//                .trim(from: 0.0, to: trimEnd)
//                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .butt))
//                .frame(width: 90, height: 90)
//                .rotationEffect(.degrees(-87))
              
            if leafLevel == 1 {
                Image("leaf0812")
                    .resizable()
                    .frame(width: 74, height: 74)
            } else if leafLevel == 2 {
                Image("orange0812")
                    .resizable()
                    .frame(width: 74, height: 74)
            } else {
                Image("kiwi")
                    .resizable()
                    .frame(width: 74, height: 74)
            }
            
        }
//        .scaleEffect(
//            (leafPosition == "left" || leafPosition == "right") ? 1.2 :
//                        ( (leafPosition == "fore") ? 1.4
//                          : 0.8 )
//        )
//        .scaleEffect(1.2)  //left and right
//        .scaleEffect(1.4)  //forward
//        .scaleEffect(0.8)  //backward
        .offset(
            x: (leafPosition == "left") ? -160 : ((leafPosition == "right") ? 160 : 0),
                y: (leafPosition == "fore") ? 130 : ((leafPosition == "back") ? -145 : 0)
        )
        
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
