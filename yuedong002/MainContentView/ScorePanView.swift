//
//  ScorePanView.swift
//  yuedong002
//
//  Created by Jzh on 2023/8/8.
//

import SwiftUI
import SceneKit

struct ScorePanView: View {
    @ObservedObject var scene: GiraffeScene
    @ObservedObject var bgmSystem: BgmSystem
    @State var scoreScale: CGFloat = 1.0
    @Binding var trimEnd: CGFloat
    
    @State var isShowPlus1 = false
    @State var isShowPlus2 = false
    @State var isShowPlus5 = false
    
    var body: some View {
        ZStack {
            Image("ruling")   //front fade-out
                .resizable()
                .padding(.all, 10)  //padding must be above frame
                .frame(width: 194, height: 194)
                .opacity(1.0)
                .offset(x: 0, y: -280)
                .mask {
                    Circle()
                        .trim(from: 0.0, to: trimEnd) //trimEnd = 1 means 360 degree
                        .stroke(style: StrokeStyle(lineWidth: 40, lineCap: .butt))
                        .foregroundColor(.gray)
                        .frame(width: 170, height: 170)
                        .padding(.all, 10)
                        .offset(x: 282, y: -2)    //-90 degree时，x=280, y=0
                        .opacity(0.6)
                        .rotationEffect(.degrees(-90))
                        .scaleEffect(x: -1, y: 1) //镜像反转 （水平翻转）
                        
                        .onChange(of: bgmSystem.currentTime) { newValue in
                            
                            trimEnd = (bgmSystem.duration - newValue) / bgmSystem.duration
                        }
                }
            
            
            //testing mask position
//            Circle()
//                .trim(from: 0.0, to: 0.95) //trimEnd = 1 means 360 degree
//                .stroke(style: StrokeStyle(lineWidth: 40, lineCap: .butt))
//                .foregroundColor(.gray)
//                .frame(width: 170, height: 170)
//                .padding(.all, 10)
//                .offset(x: 282, y: -2)    //-90 degree时，x=280, y=0
//                .opacity(0.6)
//                .rotationEffect(.degrees(-90))
//                .scaleEffect(x: -1, y: 1) //镜像反转 （水平翻转）
                
            
            
            
                
            Image("scorePan")
                .resizable()
                .padding(.all, 10)
                .frame(width: 208, height: 208)
                .offset(x: 0, y: -280)
            
            Text("\(scene.score)")
                .font(Font.custom("LilitaOne", size: 48))
                .foregroundStyle(
                      LinearGradient(
                        colors: [Color(hex: "#407800"), Color(hex: "#68A128")],  //#407800, #68A128
                        startPoint: .leading,
                        endPoint: .trailing
                      )
                )
                .frame(width: 208, height: 208)
                .padding(.all, 10)
                .offset(x: 0, y: -270)
                .foregroundColor(Color(hex: "68A128"))
                .scaleEffect(scoreScale, anchor: .center)
                .animation(.default)
                .onChange(of: scene.score) { newValue in
                    withAnimation(.easeOut(duration: 0.2)) {
                        scoreScale = 1.2
                    }
                    withAnimation(.easeOut(duration: 0.2).delay(0.2)) {
                        scoreScale = 0.9
                    }
                    withAnimation(.easeOut(duration: 0.2).delay(0.4)) {
                        scoreScale = 1.0
                    }
                    
                }
            
            HStack {
                if isShowPlus1 {
                    Text("+1")
                      .font(Font.custom("LilitaOne", size: 37.58286))
                      .kerning(0.75166)
                      .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16).opacity(0.38))
//                      .opacity(isShowPlus1 ? 1.0 : 0.0)
                      .offset(x: 0, y: -170)
                      .onAppear {
                          DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
                              withAnimation(.easeOut(duration: 0.01)) {
                                  isShowPlus1 = false
                              }
                          }
                      
                      }
                } else if isShowPlus2 {
                    Text("+2")
                      .font(Font.custom("LilitaOne", size: 37.58286))
                      .kerning(0.75166)
                      .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16).opacity(0.38))
//                      .opacity(isShowPlus2 ? 1.0 : 0.0)
                      .offset(x: 0, y: -170)
                      .onAppear {
                          DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
                              withAnimation(.easeOut(duration: 0.01)) {
                                  isShowPlus2 = false
                              }
                          }
                      
                      }
                } else if isShowPlus5 {
                    Text("+5")
                      .font(Font.custom("LilitaOne", size: 37.58286))
                      .kerning(0.75166)
                      .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16).opacity(0.38))
//                      .opacity(isShowPlus5 ? 1.0 : 0.0)
                      .offset(x: 0, y: -170)
                      .onAppear {
                          DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
                              withAnimation(.easeOut(duration: 0.01)) {
                                  isShowPlus5 = false
                              }
                          }
                      
                      }
                }
            }
            
            
            
        }
        .onChange(of: scene.isContacted, perform: { newValue in  //发生碰撞
            scene.runEatenEffect()
            if note?.level == 1{
                scene.score += 1
                withAnimation(.easeIn(duration: 0.24)) {
                    isShowPlus1 = true
                }
                
            } else if note?.level == 2 {
                scene.score += 2
                withAnimation(.easeIn(duration: 0.24)) {
                    isShowPlus2 = true
                }
            } else if note?.level == 3 {
                scene.score += 5
                withAnimation(.easeIn(duration: 0.24)) {
                    isShowPlus5 = true
                }
            }
            
            if note!.isTenuto == true {
                
            }
            if note!.isTenuto == false {
                //(eaten effect implemented in GiraffeScene)
                //remove leaf from the scene
                print("not a tenuto, remove immediately")
                
                scene.removeLeafNode()
                
            }
        })
    }
}

struct ScorePanView_Previews: PreviewProvider {
    static var previews: some View {
        ScorePanView(
            scene: GiraffeScene(),
            bgmSystem: BgmSystem(bgmURL: urlCaterpillarsFly!),
            trimEnd: .constant(1.0)
        )
    }
}
