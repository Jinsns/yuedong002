//
//  HomePageView.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/29.
//


import SwiftUI
import SceneKit


/* fonts name：
 DFPYuanW3
 DFPYuanW5
DFPYuanW7
DFPYuanW9
 */


struct HomePageView: View {
    @State var isShowAirpodsReminder = false
    @State var isShowCorrectingPositionView = true
    @State var isShowNodToEatReminder = false
    @StateObject var homePageBgmSystem = BgmSystem(bgmURL: homePageBgmURL!)
    
    @State var isShowShutterView = false
    @State var isShowSnapEffect = false
    
    @State var isShowShopView = false
    
    @ObservedObject var scene: GiraffeScene  //used to control camera height with button
    
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                Image("AirpodsReminder")
            }
            .padding(0)
            .padding(.bottom, 390)
            .scaleEffect(isShowAirpodsReminder ? 1 : 0)
//            .animation(.spring())
            .onAppear {
                withAnimation {
                    isShowAirpodsReminder = false
                }
                soundEffectSystem.overallDialogPlay()
            }
            
            if isShowCorrectingPositionView {
                CorrectingPositionView()
            }

            
//            VStack(alignment: .center, spacing: 0) {
//                Image("NodToEatReminder")
//            }
//            .padding(0)
//            .padding(.bottom, 230)
//            .scaleEffect(isShowNodToEatReminder ? 1.0 : 0.0) // 控制视图的缩放效果
//            .animation(.spring())  // 添加动画效果，这里使用了弹性动画
//            .onAppear { // 在视图出现时触发动画
//                withAnimation {
//                    isShowNodToEatReminder = true
//                }
//            }
        
            
            
            VStack {  //icons at the corners
                HStack(alignment: .top, spacing: 205) {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack(alignment: .center, spacing: 8) {  //NeckIcon  123cm
                            Image("NeckIcon")
                            .frame(width: 32, height: 32)
                            Text("123")
                              .font(Font.custom("DFPYuanW9-GB", size: 20))
                              .foregroundColor(Color(red: 0.32, green: 0.51, blue: 0.1))
                            Text("cm")
                              .font(Font.custom("DFPYuanW9-GB", size: 20))
                              .foregroundColor(Color(red: 0.32, green: 0.51, blue: 0.1))
                              .frame(width: 26, height: 14, alignment: .leading)
                        }
                        .padding(0)
                        
                        HStack(alignment: .center, spacing: 8) { //EarthIcon 地面
                            Image("EarthIcon")
                            .frame(width: 32, height: 32)
                            Text("地面")
                              .font(.custom("DFPYuanW9-GB", size: 16))
                              .kerning(1.28)
                              .foregroundColor(Color(red: 0.32, green: 0.51, blue: 0.1))
                        }
                        .padding(0)
                    }
                    .padding(0)
                    
                    
                    HStack(alignment: .center, spacing: 9.85389) {  //button hstack
                        Button {
                            print("pressed settings button")
                            soundEffectSystem.buttonPlay()
                        } label: {
                            Image("SettingsButton")
                        }
                    }
                    .frame(width: 32, height: 32, alignment: .leading)
                }  //hstack of NeckIcon, EarthIcon, SettingsButton
                .padding(.top, 70)
                
                Spacer()
                
                HStack(alignment: .top, spacing: 205) {
                    HStack(alignment: .top, spacing: 10) {
                        Button {
                            print("pressed PhotoIcon")
                            soundEffectSystem.buttonPlay()
                            isShowShutterView = true
                        } label: {
                            Image("PhotoIcon")
                        }

                    } //HStack of PhotoIcon
                    .padding(10)
                    .frame(width: 52, height: 52)

                    
                    HStack(alignment: .top, spacing: 10) {
                        Button {
                            print("pressed EyeGlassesIcon")
                            soundEffectSystem.buttonPlay()
                            isShowShopView = true
                        
                        } label: {
                            Image("EyeGlassesIcon")
                        }
                    }  //HStack of EyeGlassesIcon
                    .padding(10)
                    .frame(width: 52, height: 52)
                    
                } //HStack of PhotoIcon, EyeGlassesIcon
                .padding(.bottom, 90)
                .frame(width: 309, height: 52, alignment: .center)
                
                
                
               
                
            }
            .foregroundColor(.clear)
            .frame(width: 393, height: 852)
            .opacity(isShowShutterView || isShowShopView ? 0.0 : 1.0) //if show ShutterView, icons at corners should hide
            
            if (isShowShutterView || isShowShopView) == false {
                VStack(spacing: 30) {
                    Button {
                        print("pressed arrow up")
                        scene.cameraNode!.position = SCNVector3(
                            x: scene.cameraNode!.position.x,
                            y: (scene.cameraNode!.position.y > 7 ? 8 : scene.cameraNode!.position.y + 1),
                            z: scene.cameraNode!.position.z
                        )
                    } label: {
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 30, height: 34)
                            .foregroundColor(Color.black)
                    }
                    
                    Button {
                        print("pressed arrow down")
                        scene.cameraNode!.position = SCNVector3(
                            x: scene.cameraNode!.position.x,
                            y: (scene.cameraNode!.position.y < -1 ? -2 : scene.cameraNode!.position.y - 1),
                            z: scene.cameraNode!.position.z
                        )
                    } label: {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 30, height: 34)
                            .foregroundColor(Color.black)
                    }
                    
                }
                .offset(x: -150, y: 0)
                
            }
            

        }
        .onAppear(){
            soundEffectSystem.prepareToPlay()
            homePageBgmSystem.play()
        }
        .onDisappear() {
            print("homepage disappear, stop homepage bgm")
            homePageBgmSystem.stop()
        }
        
        if isShowShutterView {
            ShutterView(isShowShutterView: $isShowShutterView, isShowSnapEffect: $isShowSnapEffect)
        }
        
        if isShowSnapEffect {
            SnapEffectView(isShowSnapEffect: $isShowSnapEffect)
        }
        
        if isShowShopView {
            ShopView(isShowShopView: $isShowShopView)
        }
        
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        HomePageView(scene: GiraffeScene())
    }
}


struct ShutterView: View {
    @Binding var isShowShutterView: Bool
    @Binding var isShowSnapEffect: Bool
                
                
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                Button {
                    print("pressed cancel button")
                    isShowShutterView = false
                } label: {
                    Text("取消")
                      .font(Font.custom("DFPYuanW7-GB", size: 20))
                      .kerning(0.4)
                      .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16).opacity(0.8))
                }
                .padding(.top, 80)
                .padding(.leading, 300)

                
                
            }
            .padding(0)
            
            Spacer()
            
            
            HStack {
                Button {
                    print("pressed shutter button")
                    isShowSnapEffect = true
                } label: {
                    Image("shutter")
                    .frame(width: 66, height: 66)
                    .shadow(color: Color(red: 0.24, green: 0.3, blue: 0.06).opacity(0.24), radius: 4, x: 4, y: 4)
                }
                .padding(.bottom, 100)
                .opacity(isShowSnapEffect ? 0.0 : 1.0)

                
            }
        }

    }
}


struct SnapEffectView: View {
    @Binding var isShowSnapEffect: Bool
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
                .reverseMask{
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 340, height: 580)
                        .blendMode(.destinationOut)
                        .padding(.bottom, 50)
                }
                    
                
            
            VStack {
                HStack(alignment: .top, spacing: 12) {
                    Text("7")
                      .font(Font.custom("LilitaOne", size: 32))
                      .kerning(2.56)
                      .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                      .padding(.bottom, 30)
                    
                    Text("| 25")
                      .font(Font.custom("LilitaOne", size: 14))
                      .kerning(1.12)
                      .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16).opacity(0.6))
                    
                    Text("宜放过自己")
                      .font(Font.custom("DFPYuanW9-GB", size: 14))
                      .kerning(0.56)
                      .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                      .frame(width: 73, height: 13, alignment: .leading)
                }
                .offset(x: -80, y: -200)
                
                
                
                HStack(alignment: .bottom) {
                    Text("Yoon")
                      .font(Font.custom("LilitaOne", size: 24))
                      .kerning(0.48)
                      .multilineTextAlignment(.trailing)
                      .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16).opacity(0.56))
                }
                .offset(x: 100, y: 200)
               
                
                
                HStack(alignment: .top, spacing: 42) {
                    
                    Button {
                        print("pressed reshot button")
                        isShowSnapEffect = false
                    
                        
                    } label: {
                        VStack(spacing: 4) {
                            Image("reshot")
                                .frame(width: 36, height: 36)
                            Text("重拍")
                              .font(Font.custom("DFPYuanW7-GB", size: 14))
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                        }
                    }
                    
                    Button {
                        print("pressed save button")
                    } label: {
                        VStack(spacing: 4) {
                            Image("save")
                                .frame(width: 36, height: 36)
                            Text("保存")
                              .font(Font.custom("DFPYuanW7-GB", size: 14))
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                        }
                    }
                    
                    Button {
                        print("pressed QQ login button")
                    } label: {
                        VStack(spacing: 4) {
                            Image("qqlogin")
                                .frame(width: 36, height: 36)
                            Text("QQ")
                              .font(Font.custom("DFPYuanW7-GB", size: 14))
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                        }
                    }
                    
                    Button {
                        print("pressed WeChat login button")
                    } label: {
                        VStack(spacing: 4) {
                            Image("wechatlogin")
                                .frame(width: 36, height: 36)
                            Text("微信")
                              .font(Font.custom("DFPYuanW7-GB", size: 14))
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                        }
                    }
                }
                .offset(x: 0, y: 280)
            
                
            }

            
            
        }
        
        
    }
}


extension View {
  @inlinable
  public func reverseMask<Mask: View>(
    alignment: Alignment = .center,
    @ViewBuilder _ mask: () -> Mask
  ) -> some View {
    self.mask {
      Rectangle()
        .overlay(alignment: alignment) {
          mask()
            .blendMode(.destinationOut)
        }
    }
  }
}


struct CorrectingPositionView: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .center, spacing: 4) {
                Text("摆正头部位置")
                  .font(Font.custom("DFPYuanW9-GB", size: 20))
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.25, green: 0.47, blue: 0))
                
                Text("x: 12.56（0）\ny: 13.44（0）\nz: 20.44（0）")
                  .font(Font.custom("DFPYuanW9-GB", size: 14))
                  .foregroundColor(Color(red: 0.32, green: 0.51, blue: 0.1))
            }
                .padding(.horizontal, 16)
                .background(.white.opacity(0.7))
                .cornerRadius(8)
            
            Image("DownTriangle")
                .frame(width: 33.00003, height: 11.0933)
                .offset(x: 0, y: -1)
                .opacity(0.7)
        }
        .padding(.bottom, 390)
        
        
    }
}
