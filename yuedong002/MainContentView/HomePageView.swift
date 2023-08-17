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
    @Binding var totalLeaves: String
    @Binding var neckLength: String
    @Binding var worldName: String
    
//    @State var isShowAirpodsReminder = true
//    @State var isShowCorrectingPositionView = false
//    @State var isShowNodToEatView = false
    @StateObject var homePageBgmSystem = BgmSystem(bgmURL: homePageBgmURL!)
    
    @State var isShowShutterView = false
    @State var isShowSnapEffect = false
    
    @State var isShowShopView = false
    
    @ObservedObject var scene: GiraffeScene  //used to control camera height with button
    @ObservedObject var dataModel: DataModel
    
    @Binding var isLeafAdded: Bool
    
    
    
    
    var body: some View {
        ZStack {
            if isShowShopView == false && isShowShutterView == false {
                if dataModel.isShowAirpodsReminder {
                    WearAirpodsReminderView(isShowAirpodsReminder: $dataModel.isShowAirpodsReminder)
                }
                
                if dataModel.isShowCorrectingPositionView {
                    CorrectingPositionView(scene: scene)
                        .onAppear(){
//                            scene.stopMotionUpdates()
                            scene.addNeckRotation()
                            print("checkingposition start")
//                            scene.checkingPosition()
                        }
                        .onDisappear {
//                            scene.stopMotionUpdates()
//                            scene.addNeckRotation()
                        }
                }
                
                if dataModel.isShowNodToEatView {
                    NodToEatView()
                    leaf1(leafPosition: .constant("fore"), leafLevel: .constant(1), isTenuto: .constant(false))
                        .onAppear() {
                            isLeafAdded = true
                            scene.addLeafNode(xPosition: note!.leafPosition.x, yPosition: note!.leafPosition.y, zPosition: note!.leafPosition.z, level: note!.level, noteUIPosition: noteUI!.leafPosition)
                        }
                }
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
                            Text("\(neckLength)")
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
                            Text("\(worldName)")
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
//                            soundEffectSystem.buttonPlay()
                            if let url = Bundle.main.url(forResource: "Overall_ClickButton", withExtension: "mp3") {
                                        let player = AVAudioPlayerPool().playerWithURL(url: url)
                                        player?.play()
                                    }
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
//                            soundEffectSystem.buttonPlay()
                            if let url = Bundle.main.url(forResource: "Overall_ClickButton", withExtension: "mp3") {
                                        let player = AVAudioPlayerPool().playerWithURL(url: url)
                                        player?.play()
                                    }
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
//                            soundEffectSystem.buttonPlay()
                            if let url = Bundle.main.url(forResource: "Overall_ClickButton", withExtension: "mp3") {
                                        let player = AVAudioPlayerPool().playerWithURL(url: url)
                                        player?.play()
                                    }
                            isShowShopView = true
                            scene.moveCameraNodeAndNeckNodeToShopPosition()
                        
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
            
            //if not in these two view
            if (isShowShutterView || isShowShopView) == false {
                ArrowButtonsView(scene: scene, dataModel: dataModel)
                
            }
            

        }
        .onAppear(){
//            soundEffectSystem.prepareToPlay()
            
            homePageBgmSystem.play()
            scene.checkingAirpods()
            scene.isPositionReady = false
//            isShowCorrectingPositionView = false
            dataModel.isShowAirpodsReminder = true
            if scene.isAirpodsAvailable {
                dataModel.isShowAirpodsReminder = false
                dataModel.isShowCorrectingPositionView = true
            }
            
            scene.physicsWorld.contactDelegate = nil  //先消除碰撞检测，不让他开始
            
            
            
        }
        .onChange(of: scene.isAirpodsAvailable, perform: { newValue in
            if newValue == false {
                dataModel.isShowCorrectingPositionView = false
                withAnimation(.default) {
                    dataModel.isShowAirpodsReminder = true
                }
            } else if newValue == true {
//                scene.checkingPosition()
                withAnimation(.default) {
                    dataModel.isShowAirpodsReminder = false
                    dataModel.isShowCorrectingPositionView = true
                }
            }
        })
        .onChange(of: scene.isPositionReady, perform: { newValue in
            if newValue == true {
                withAnimation(.default) {
                    dataModel.isShowCorrectingPositionView = false
                    dataModel.isShowNodToEatView = true
                }
//                scene.stopMotionUpdates()
//                scene.addNeckRotation()
                scene.physicsWorld.contactDelegate = scene
            }
        })
        .onDisappear() {
            print("homepage disappear, stop homepage bgm")
            homePageBgmSystem.stop()
            isShowShopView = false
            isShowSnapEffect = false
            isShowShutterView = false
            dataModel.isShowAirpodsReminder = false
            dataModel.isShowCorrectingPositionView = false
            dataModel.isShowNodToEatView = false
        }
        
        if isShowShutterView {
            ShutterView(isShowShutterView: $isShowShutterView, isShowSnapEffect: $isShowSnapEffect)
                .onAppear() {
                    scene.addCameraRotation()
                }
                .onDisappear() {
                    scene.stopCameraRotation()
                    scene.rotateBackNeckNode()
                }
        }
        
        if isShowSnapEffect {
            SnapEffectView(isShowSnapEffect: $isShowSnapEffect)
                .onAppear() {
                    scene.physicsWorld.contactDelegate = nil
                }
                .onDisappear() {
                    scene.physicsWorld.contactDelegate = scene
                }
        }
        
        if isShowShopView {
            ShopView(totalLeaves: $totalLeaves, isShowShopView: $isShowShopView, scene: scene)
                .onDisappear() {
                    scene.rotateBackNeckNode()
                }
        }
        
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        HomePageView(totalLeaves: .constant("1443"), neckLength: .constant("100"), worldName: .constant("地面"), scene: GiraffeScene(), dataModel: DataModel(), isLeafAdded: .constant(true))
            .previewDevice("iPhone 13 mini")
//        ShutterView(isShowShutterView: .constant(true), isShowSnapEffect: .constant(false))
//            .previewDevice("iPhone 13 mini")
    
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
                    if let url = Bundle.main.url(forResource: "Camera_PressShutter", withExtension: "mp3") {
                        let player = AVAudioPlayerPool().playerWithURL(url: url)
                        player?.play()
                    }
                    withAnimation(.linear(duration: 0.6)) {
                        isShowSnapEffect = true
                    }
                    
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
                .offset(x: 0, y: -10)
                    
                
            
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

struct WearAirpodsReminderView: View {
    @Binding var isShowAirpodsReminder: Bool
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("AirpodsReminder")
        }
        .padding(0)
        .padding(.bottom, 390)
        .scaleEffect(isShowAirpodsReminder ? 1 : 0)
        .onAppear {
//            withAnimation {
//                isShowAirpodsReminder = true
//            }
//            soundEffectSystem.overallDialogPlay()
            if let url = Bundle.main.url(forResource: "Overall_Dialog", withExtension: "mp3") {
                        let player = AVAudioPlayerPool().playerWithURL(url: url)
                        player?.play()
                    }
        }
    }
}


struct CorrectingPositionView: View {
    @ObservedObject var scene: GiraffeScene
    
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .center, spacing: 4) {
                Text("摆正头部位置至\n(0, 0)")
                  .font(Font.custom("DFPYuanW9-GB", size: 20))
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.25, green: 0.47, blue: 0))
                  .lineSpacing(12)
                
                Text(String(format: "(左右方向 %.1f, 前后方向 %.1f)", Float(scene.headphoneAnglex), Float(scene.headphoneAnglez) ) )
                  .font(Font.custom("DFPYuanW9-GB", size: 14))
                  .foregroundColor(Color(red: 0.32, green: 0.51, blue: 0.1))
                  .padding(10)
                  
            }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(.white.opacity(0.7))
                .cornerRadius(8)
            
            Image("DownTriangle")
                .frame(width: 33.00003, height: 11.0933)
                .offset(x: 0, y: -1)
                .opacity(0.7)
        }
        .padding(.bottom, 370)
        
        
    }
}

struct NodToEatView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("NodToEatReminder")
        }
        .padding(.bottom, 390)
    }
}

struct ArrowButtonsView: View {
    
    @ObservedObject var scene: GiraffeScene
    @ObservedObject var dataModel: DataModel
//    @Binding var isShowAirpodsReminder: Bool
//    @Binding var isShowCorrectingPositionView: Bool
//    @Binding var isShowNodToEatView: Bool
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Button {
                    print("pressed up arrow button")
                    if dataModel.isShowAirpodsReminder == true {
                        dataModel.isShowAirpodsReminder = false
                        if scene.cameraNode!.position.y >= 2 {
                            scene.moveCameraNodeSmoothly(newPosition: SCNVector3(
                                x: scene.cameraNode!.position.x,
                                y: 8.0,
                                z: scene.cameraNode!.position.z)
                            )
                        } else {
                            scene.moveCameraNodeSmoothly(newPosition: SCNVector3(
                                x: scene.cameraNode!.position.x,
                                y: 2.0,
                                z: scene.cameraNode!.position.z)
                            )
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            dataModel.isShowAirpodsReminder = true
                        }
                    } else if dataModel.isShowCorrectingPositionView == true {
                        dataModel.isShowCorrectingPositionView = false
                        if scene.cameraNode!.position.y >= 2 {
                            scene.moveCameraNodeSmoothly(newPosition: SCNVector3(
                                x: scene.cameraNode!.position.x,
                                y: 8.0,
                                z: scene.cameraNode!.position.z)
                            )
                        } else {
                            scene.moveCameraNodeSmoothly(newPosition: SCNVector3(
                                x: scene.cameraNode!.position.x,
                                y: 2.0,
                                z: scene.cameraNode!.position.z)
                            )
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            dataModel.isShowCorrectingPositionView = true
                        }
//                        dataModel.isShowCorrectingPositionView = true
                    } else if dataModel.isShowNodToEatView == true {
                        dataModel.isShowNodToEatView = false
                        if scene.cameraNode!.position.y >= 2 {
                            scene.moveCameraNodeSmoothly(newPosition: SCNVector3(
                                x: scene.cameraNode!.position.x,
                                y: 8.0,
                                z: scene.cameraNode!.position.z)
                            )
                        } else {
                            scene.moveCameraNodeSmoothly(newPosition: SCNVector3(
                                x: scene.cameraNode!.position.x,
                                y: 2.0,
                                z: scene.cameraNode!.position.z)
                            )
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            dataModel.isShowNodToEatView = true
                        }
                        
                    }
                    
                    
                    
                    
                    
                } label: {
                    Image("ArrowUp")
                          .frame(width: 32, height: 32)
                }
              
            }
            .buttonStyle(MyButtonStyle(color: .green))
            
            VStack(alignment: .leading) {
                Button {
                    print("pressed down arrow botton")
                    if dataModel.isShowAirpodsReminder {
                        dataModel.isShowAirpodsReminder = false
                        if scene.cameraNode!.position.y > 2 {
                            scene.moveCameraNodeSmoothly(newPosition: SCNVector3(
                                x: scene.cameraNode!.position.x,
                                y: 2.0,
                                z: scene.cameraNode!.position.z)
                            )
                        } else {
                            scene.moveCameraNodeSmoothly(newPosition: SCNVector3(
                                x: scene.cameraNode!.position.x,
                                y: -1.5,
                                z: scene.cameraNode!.position.z)
                            )
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            dataModel.isShowAirpodsReminder = true
                        }
                    } else if dataModel.isShowCorrectingPositionView {
                        dataModel.isShowCorrectingPositionView = false
                        if scene.cameraNode!.position.y > 2 {
                            scene.moveCameraNodeSmoothly(newPosition: SCNVector3(
                                x: scene.cameraNode!.position.x,
                                y: 2.0,
                                z: scene.cameraNode!.position.z)
                            )
                        } else {
                            scene.moveCameraNodeSmoothly(newPosition: SCNVector3(
                                x: scene.cameraNode!.position.x,
                                y: -1.5,
                                z: scene.cameraNode!.position.z)
                            )
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            dataModel.isShowCorrectingPositionView = true
                        }
                        
                    } else if dataModel.isShowNodToEatView {
                        dataModel.isShowNodToEatView = false
                        if scene.cameraNode!.position.y > 2 {
                            scene.moveCameraNodeSmoothly(newPosition: SCNVector3(
                                x: scene.cameraNode!.position.x,
                                y: 2.0,
                                z: scene.cameraNode!.position.z)
                            )
                        } else {
                            scene.moveCameraNodeSmoothly(newPosition: SCNVector3(
                                x: scene.cameraNode!.position.x,
                                y: -1.5,
                                z: scene.cameraNode!.position.z)
                            )
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            dataModel.isShowNodToEatView = true
                        }
                        
                    }
                                        
                } label: {
                    Image("ArrowDown")
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(MyButtonStyle(color: .green))
                
                
            }
            
            

        }
//        .padding(0)
        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 0)
        .background(RoundedRectangle(cornerRadius: 50).fill(Color.white.opacity(0.7)))
        .offset(x: 132, y: 200)
    }
}


struct MyButtonStyle: ButtonStyle {
    var color: Color = .green

    public func makeBody(configuration: MyButtonStyle.Configuration) -> some View {

        configuration.label
            .padding(10)
            .frame(width: 52, height: 56, alignment: .leading)
            .scaledToFit()
            .background(configuration.isPressed ? Color(red: 0.41, green: 0.44, blue: 0.54).opacity(0.12) : Color.clear)
            .clipShape(Capsule())
//            .mask(RoundedRectangle(cornerRadius: 50).fill(Color.white.opacity(0.7)))
            
    }
}
