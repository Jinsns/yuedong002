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
    @Binding var totalLeaves: Int
    @Binding var neckLength: Int
    @Binding var worldName: String
    
//    @State var isShowAirpodsReminder = true
//    @State var isShowCorrectingPositionView = false
//    @State var isShowNodToEatView = false
    @EnvironmentObject var bgmSystem: BgmSystem
    @StateObject var homePageBgmSystem = BgmSystem(bgmURL: homePageBgmURL!)
    
    @State var isShowShutterView = false
    @State var isShowSnapEffect = false
    
    @State var isShowShopView = false
    
    @ObservedObject var scene: GiraffeScene  //used to control camera height with button
    @EnvironmentObject var dataModel: DataModel
    
    @Binding var isLeafAdded: Bool
    
    @Binding var viewState: Int
    
    @State var capturedImage: UIImage?
    @State var isShowSaveShareIcons = false
    
    
    
    
    var body: some View {
        ZStack {
            if isShowShopView == false && isShowShutterView == false && viewState == 2{
                if dataModel.isShowAirpodsReminder {
                    WearAirpodsReminderView(isShowAirpodsReminder: $dataModel.isShowAirpodsReminder)
                }
                
                if dataModel.isShowCorrectingPositionView && viewState == 2 {
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
                
                if dataModel.isShowNodToEatView && viewState == 2{
                    NodToEatView()
                    leaf1(leafPosition: .constant("fore"), leafLevel: .constant(1), isTenuto: .constant(false))
                        .onAppear() {
                            isLeafAdded = true
                            scene.addLeafNode(xPosition: note!.leafPosition.x, yPosition: note!.leafPosition.y, zPosition: note!.leafPosition.z, level: note!.level, noteUIPosition: noteUI!.leafPosition)
                        }
                }
                
                
                
            }
            
            if dataModel.isShowSettingsView {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.1)
                    .onTapGesture {
                        dataModel.isShowSettingsView = false
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
                HStack(alignment: .top, spacing: 0) {
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
//                            Text("\(worldName)")
                            Text("\(worldName)")
                              .font(.custom("DFPYuanW9-GB", size: 16))
                              .kerning(1.28)
                              .foregroundColor(Color(red: 0.32, green: 0.51, blue: 0.1))
                              .frame(width: .infinity, height: .infinity)
                        }
                        .padding(0)
                        .frame(width: .infinity, height: .infinity)
                    }
                    .padding(.leading, 30)
                    .frame(width: .infinity, height: .infinity)
                    
                    Spacer()
                    
                    
                    VStack(alignment: .trailing, spacing: 0) {  //button hstack
                        Button {
                            print("pressed settings button")
                            withAnimation {
                                dataModel.isShowSettingsView.toggle()
                            }
                            
//                            soundEffectSystem.buttonPlay()
                            if let url = Bundle.main.url(forResource: "Overall_ClickButton", withExtension: "mp3") {
                                let player = AVAudioPlayerPool().playerWithURL(url: url)
                                player?.play()
                            }
                        } label: {
                            Image("SettingsButton")
                        }
                        
                        if dataModel.isShowSettingsView {
                            ExpandedSettingsView(dataModel: dataModel, bgmSystem: bgmSystem, totalLeaves: $totalLeaves, scene: scene, worldName: $worldName)
                        }
                        
                    }
                    .padding(.trailing, 32)
                    .frame(width: .infinity, height: .infinity, alignment: .leading)
                }  //hstack of NeckIcon, EarthIcon, SettingsButton
                .padding(.top, 70)
                .frame(width: .infinity, height: .infinity)
                
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
                ArrowButtonsView(scene: scene, dataModel: dataModel, worldName: $worldName, viewState: $viewState)
                
                if dataModel.isShowCannotSeeHigherView {
                    CannotSeeHigherReminder()
                        .onAppear() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                withAnimation(.easeOut(duration:0.5)) {
                                    dataModel.isShowCannotSeeHigherView = false
                                }
                            }
                        }
                }
                
                if dataModel.isShowCannotSeeLowerView {
                    CannotSeeLowerReminder()
                        .onAppear() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                withAnimation(.easeOut(duration:0.5)) {
                                    dataModel.isShowCannotSeeLowerView = false
                                }
                            }
                        }
                }
                
                if dataModel.isShowAlarmSettingView {
                    
                    Color.black.opacity(0.1)  //darken background of alarmsettingview
                        .ignoresSafeArea()
                        .onTapGesture {
                            dataModel.isShowAlarmSettingView = false
                            dataModel.isBlurScene = false
                        }

                    AlarmSettingView(dataModel: dataModel)
                        .onAppear() {
                            scene.stopMotionUpdates()
                        }
                        .onDisappear() {
                            scene.addNeckRotation()
                            dataModel.isBlurScene = false
                        }
                    
                }
                
                
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
            ShutterView(isShowShutterView: $isShowShutterView, isShowSnapEffect: $isShowSnapEffect, capturedImage: $capturedImage, isShowSaveShareIcons: $isShowSaveShareIcons)
                .onAppear() {
                    scene.addCameraRotation()
                }
                .onDisappear() {
                    scene.stopCameraRotation()
                    scene.rotateBackNeckNode()
                }
        }
        
        if isShowSnapEffect {
            SnapEffectView(isShowSnapEffect: $isShowSnapEffect, capturedImage: $capturedImage, isShowSaveShareIcons: $isShowSaveShareIcons)
                .onAppear() {
                    scene.physicsWorld.contactDelegate = nil
                    scene.stopMotionUpdates()
                    scene.stopCameraRotation()
                }
                .onDisappear() {
                    scene.physicsWorld.contactDelegate = scene
                    scene.addNeckRotation()
                    scene.addCameraRotation()
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
        HomePageView(totalLeaves: .constant(1443), neckLength: .constant(100), worldName: .constant("地面"), scene: GiraffeScene(),  isLeafAdded: .constant(true), viewState: .constant(2))
            .environmentObject(DataModel())
//            .previewDevice("iPhone 13 mini")
//        ShutterView(isShowShutterView: .constant(true), isShowSnapEffect: .constant(false))
//            .previewDevice("iPhone 13 mini")
//        SnapEffectView(isShowSnapEffect: .constant(true))
//            .previewDevice("iPhone 13 mini")
        
        
    
    }
}


struct ShutterView: View {
    @Binding var isShowShutterView: Bool
    @Binding var isShowSnapEffect: Bool
    @Binding var capturedImage: UIImage?
    @Binding var isShowSaveShareIcons: Bool
                
                
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        capturedImage = takeScreenshot()  //截图
                        isShowSaveShareIcons = true
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
    @EnvironmentObject var dataModel: DataModel
    @State var isShowSavedView = false
    
    @Binding var capturedImage: UIImage?
    @State var month: String = "10"
    @State var day: String = "8"
    @State var isShowShareLink: Bool = false
    @Binding var isShowSaveShareIcons: Bool
    
    var body: some View {
        ZStack{
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(Color.black.opacity(0.5))
                .reverseMask{
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 340, height: 580)
                        .blendMode(.destinationOut)
                        .padding(.bottom, 50)
                }
//                .offset(x: 0, y: -10)
                    
                
            VStack {
                Spacer()
                VStack {
                    HStack {
                        HStack(alignment: .bottom, spacing: 12) {
                            Text(month)
                              .font(Font.custom("LilitaOne", size: 32))
                              .kerning(2.56)
                              .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                              .offset(x: 0, y: 6)
                            
                            Text("| \(day)")
                              .font(Font.custom("LilitaOne", size: 14))
                              .kerning(1.12)
                              .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16).opacity(0.6))
                            
                            Text("宜放过自己")
                              .font(Font.custom("DFPYuanW9-GB", size: 14))
                              .kerning(0.56)
                              .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                              .frame(width: 73, height: 13, alignment: .leading)
                        }
                        .padding(.leading, 30)

                        Spacer()
                    }
                    .padding(.top, 20)
                    
                
                    
                    
                    
                    Spacer()
                    
                    
                    
                    VStack {
//                        Spacer()
                        HStack(alignment: .bottom) {
                            Spacer()
                            Text("Yoon")
                              .font(Font.custom("LilitaOne", size: 24))
                              .kerning(0.48)
                              .multilineTextAlignment(.trailing)
                              .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16).opacity(0.56))
                              .padding(.trailing, 50)
                        }
                        .padding(.bottom, 50)
                    }
                    
                
                    
                }
                .frame(width: 340, height: 580)
//                .background(
//                    RoundedRectangle(cornerRadius: 16)
////
//                        .foregroundColor(.white)
//                )
                .padding(.top, 36)
                
                Spacer()
                
                if isShowSaveShareIcons {
                    HStack(alignment: .bottom, spacing: 42) {
                        
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
                            dataModel.isSnapShotted.toggle()
                            withAnimation(.easeIn(duration: 0.6)) {
                                isShowSavedView = true
                            }
    //                        capturedImage = takeScreenshot()
                            saveToPhotoLibrary()
                            
                            
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
                            isShowShareLink = true
                            
                            
                        } label: {
                            VStack(spacing: 4) {
    //                            Image("qqlogin")
    //                                .frame(width: 36, height: 36)
                                ShareLink(item: Image(uiImage: cropSnapShot(sourceImage: capturedImage!)), preview: SharePreview("你的长颈鹿照片", image: Image(uiImage: cropSnapShot(sourceImage: capturedImage!)))) {
                                    Image("share")
                                        .frame(width: 36, height: 36)
//                                    Label("", image: "qqlogin")
//                                        .frame(width: 36, height: 36)
                                }
                                Text("分享")
                                  .font(Font.custom("DFPYuanW7-GB", size: 14))
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(.white)
                            }
                        }
                    }
                    .offset(x: 0, y: -50)
    //                .padding(.bottom, 30)
                }
                
            }
            
            if isShowSavedView {
                Image("saveToAlbum")
                    .offset(x: 0, y: -170)
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeOut(duration: 0.6)) {
                                isShowSavedView = false
                            }
                        }
                        
                    }
            }
            
//            if let image = capturedImage {
//                Image(uiImage: cropSnapShot(sourceImage: image))
////                    .resizable()
////                    .scaledToFit()
////                    .frame(width: 200, height: 200)
//            } else {
////                Text("No Image Captured")
//            }

            
            
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
//            dataModel.isSnapShotted.toggle()
            let currentDate = currentDate()
            month = currentDate.components(separatedBy: "-")[1]
            day = currentDate.components(separatedBy: "-")[2]
        }
        
        
    }
    
    func takeScreenshot() -> UIImage? {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        UIGraphicsBeginImageContextWithOptions(window?.frame.size ?? CGSize.zero, false, 0)
        window?.drawHierarchy(in: window?.bounds ?? CGRect.zero, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }

    func saveToPhotoLibrary() {
        let croppedImage = cropSnapShot(sourceImage: capturedImage!)
        UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)
    }
    
    func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let datetime = formatter.string(from: Date())
        return datetime
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
    @Binding var worldName: String
    @Binding var viewState: Int   // 下1 中2 上3
//    @Binding var isShowAirpodsReminder: Bool
//    @Binding var isShowCorrectingPositionView: Bool
//    @Binding var isShowNodToEatView: Bool
    
    
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Button {
                    print("pressed up arrow button")
                    
                    if worldName == "地面" {
                        if viewState == 2 {
                            scene.world1ViewMid2Up()
                            viewState = 3
                        } else if viewState == 1 {
                            scene.world1ViewDown2Mid()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                viewState = 2
                            }
                            
                        } else if viewState == 3 {
                            withAnimation(.easeIn(duration: 0.5)) {
                                dataModel.isShowCannotSeeHigherView = true
                            }
                            
                        }
                        
                    } else if worldName == "魔幻森林" {
                        if viewState == 2 {
                            scene.world2ViewMid2Up()
                            viewState = 3
                        } else if viewState == 1 {
                            scene.world2ViewDown2Mid()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                viewState = 2
                            }
                        } else if viewState == 3 {
                            withAnimation(.easeIn(duration: 0.5)) {
                                dataModel.isShowCannotSeeHigherView = true
                            }
                            
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
                    if worldName == "地面" {
                        if viewState == 3 {
                            scene.world1ViewUp2Mid()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                viewState = 2
                            }
                        } else if viewState == 2 {
                            scene.world1ViewMid2Down()
                            viewState = 1
                        } else if viewState == 1 {
                            withAnimation(.easeIn(duration: 0.5)) {
                                dataModel.isShowCannotSeeLowerView = true
                            }
                            
                        }
                        
//                        if dataModel.isShowAirpodsReminder {
//                            dataModel.isShowAirpodsReminder = false
//                            if viewState == 3 {
//                                scene.world1ViewUp2Mid()
//                                viewState = 2
//                            } else if viewState == 2 {
//                                scene.world1ViewMid2Down()
//                                viewState = 1
//                            } else if viewState == 1 {
//                                dataModel.isShowCannotSeeLowerView = true
//                            }
//
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
//                                dataModel.isShowAirpodsReminder = true
//                            }
//                        } else if dataModel.isShowCorrectingPositionView {
//                            dataModel.isShowCorrectingPositionView = false
//                            if viewState == 3 {
//                                scene.world1ViewUp2Mid()
//                                viewState = 2
//                            } else if viewState == 2 {
//                                scene.world1ViewMid2Down()
//                                viewState = 1
//                            }
//
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
//                                dataModel.isShowCorrectingPositionView = true
//                            }
//
//                        } else if dataModel.isShowNodToEatView {
//                            dataModel.isShowNodToEatView = false
//
//                            if viewState == 3 {
//                                scene.world1ViewUp2Mid()
//                                viewState = 2
//                            } else if viewState == 2 {
//                                scene.world1ViewMid2Down()
//                                viewState = 1
//                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
//                                dataModel.isShowNodToEatView = true
//                            }
//
//                        }

                    } else if worldName == "魔幻森林" {
                        if viewState == 3 {
                            scene.world2ViewUp2Mid()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                viewState = 2
                            }
                        } else if viewState == 2 {
                            scene.world2ViewMid2Down()
                            viewState = 1
                        } else if viewState == 1 {
                            withAnimation(.easeIn(duration: 0.5)) {
                                dataModel.isShowCannotSeeLowerView = true
                            }
                        }
                        
//                        if dataModel.isShowAirpodsReminder {
//                            dataModel.isShowAirpodsReminder = false
//
//                            if viewState == 3 {
//                                scene.world2ViewUp2Mid()
//                                viewState = 2
//                            } else if viewState == 2 {
//                                scene.world2ViewMid2Down()
//                                viewState = 1
//                            }
//
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
//                                dataModel.isShowAirpodsReminder = true
//                            }
//                        } else if dataModel.isShowCorrectingPositionView {
//                            dataModel.isShowCorrectingPositionView = false
//
//                            if viewState == 3 {
//                                scene.world2ViewUp2Mid()
//                                viewState = 2
//                            } else if viewState == 2 {
//                                scene.world2ViewMid2Down()
//                                viewState = 1
//                            }
//
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
//                                dataModel.isShowCorrectingPositionView = true
//                            }
//
//                        } else if dataModel.isShowNodToEatView {
//                            dataModel.isShowNodToEatView = false
//
//                            if viewState == 3 {
//                                scene.world2ViewUp2Mid()
//                                viewState = 2
//                            } else if viewState == 2 {
//                                scene.world2ViewMid2Down()
//                                viewState = 1
//                            }
//
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
//                                dataModel.isShowNodToEatView = true
//                            }
//
//                        }

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
//        .onChange(of: viewState) { newValue in
//            if newValue != 2 {
//                scene.rotateBackNeckNode()
//                scene.stopMotionUpdates()
//            } else {
//                scene.addNeckRotation()
//            }
//        }
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


func cropSnapShot(sourceImage: UIImage) -> UIImage {
    
//    .reverseMask{
//        RoundedRectangle(cornerRadius: 16)
//            .frame(width: 340, height: 580)
//            .blendMode(.destinationOut)
//            .padding(.bottom, 50)
//    }
    
    // about UIImage and CGImage
    //https://stackoverflow.com/questions/35945493/why-is-my-cgimage-3-x-the-size-of-the-uiimage
    //It's because UIImage has a scale property. This mediates between pixels and points. So, for example, a UIImage created from a 180x180 pixel image, but with a scale of 3, is automatically treated as having size 60x60 points. It will report its size as 60x60, and will also look good on a 3x resolution screen where 3 pixels correspond to 1 point. And, as you rightly guess, the @3x suffix, or the corresponding location in the asset catalog, tells the system to give the UIImage a scale of 3 as it forms it.
    //  But a CGImage does not have such a property; it's just a bitmap, the actual pixels of the image. So a CGImage formed from a UIImage created from 180x180 pixel image is 180x180 points as well.
    
//    let sideLength = min(sourceImage.size.width, sourceImage.size.height) //短边
//    let sourceSize = sourceImage.size
//
//    //宽是短边，所以xOffset = 0
//    let xOffset = (sourceSize.width - sideLength) / 2.0
//    let yOffset = (sourceSize.height - sideLength) / 2.0
//
//    let cropRect = CGRect(
//        x: xOffset * 3, y: yOffset * 3,
//        width: sideLength * 3, height: sideLength * 3
//    ).integral
    
    let sourceSize = sourceImage.size
    let xOffset = 18.0
    let yOffset = 130.0
    let cropRect = CGRect(
        x: xOffset * 3,
        y: yOffset * 3,
        width: (sourceSize.width - 2.0 * xOffset) * 3.0,
        height: (sourceSize.height - 2.0 * yOffset) * 3.0
    ).integral
    
    let sourceCGImage = sourceImage.cgImage!
    let croppedCGImage = sourceCGImage.cropping(to: cropRect)!
    
    let croppedIamge = UIImage(
        cgImage: croppedCGImage,
        scale: sourceImage.imageRendererFormat.scale,
        orientation: sourceImage.imageOrientation
    )
    return croppedIamge
}
