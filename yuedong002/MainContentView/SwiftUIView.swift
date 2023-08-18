//
//  SwiftUIView.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/23.
//

import SwiftUI
import SceneKit

let neckLengthLevel: [Int] = [120, 200]

//let soundEffectSystem = SoundEffectSystem()


//延音时长统一为4秒，bgm虫儿飞时长58秒
let notes: [Note] = [
    //x 大 屏幕外
    //y 大 屏幕上
    //z 大 屏幕左， x，z和头运动方向一致
    
    Note(startTime: 0.0, endTime: 0.01, leafPosition: SCNVector3(x: 3.0, y: -1.0, z: 0), isTenuto: false, level: 1), //吃掉第一个叶子启动游戏，位置固定在正下方
    
    Note(startTime: 4.0, endTime: 8.0, leafPosition: SCNVector3(x: 0, y: 1, z: 3.8), isTenuto: true, level: 1), //左
    Note(startTime: 10.0, endTime: 14.0, leafPosition: SCNVector3(x: 0, y: 1, z: -3.8), isTenuto: true, level: 1), //右
    Note(startTime: 16.0, endTime: 20.0, leafPosition: SCNVector3(x: 0, y: 1, z: 3.8), isTenuto: true, level: 2), //左
    Note(startTime: 22.0, endTime: 26.0, leafPosition: SCNVector3(x: 0, y: 1, z: -3.8), isTenuto: true, level: 2), //右
    Note(startTime: 30.0, endTime: 34.0, leafPosition: SCNVector3(x: 3.8, y: 1.2, z: -0.0), isTenuto: true, level: 3),  //前
    Note(startTime: 36.0, endTime: 40.0, leafPosition: SCNVector3(x: 3.8, y: 1.2, z: -0.0), isTenuto: true, level: 3),  //前
    Note(startTime: 42.0, endTime: 46.0, leafPosition: SCNVector3(x: -3.8, y: 1.2, z: -0.0), isTenuto: true, level: 2),  //后
    Note(startTime: 48.0, endTime: 52.0, leafPosition: SCNVector3(x: -3.8, y: 1.2, z: -0.0), isTenuto: true, level: 3),  //后
    
    Note(startTime: 65.0, endTime: 75.0, leafPosition: SCNVector3(x: 1.5, y: -1.5, z: -1), isTenuto: true, level: 1)  //最后添加一个开始时间大于歌曲时长的，避免array index out of range
]

let noteUIs: [NoteUI] = [
    NoteUI(startTime: 0.0, endTime: 0.01, leafPosition: "fore", isTenuto: false, level: 1),   //平面ui 不要第一个叶子，第一个叶子用三维模型做
    
    NoteUI(startTime: 4.0, endTime: 8.0, leafPosition: "left", isTenuto: true, level: 1),
    NoteUI(startTime: 10.0, endTime: 14.0, leafPosition: "right", isTenuto: true, level: 1),
    NoteUI(startTime: 16.0, endTime: 20.0, leafPosition: "left", isTenuto: true, level: 2),
    NoteUI(startTime: 22.0, endTime: 26.0, leafPosition: "right", isTenuto: true, level: 2),
    NoteUI(startTime: 30.0, endTime: 34.0, leafPosition: "fore", isTenuto: true, level: 3),
    NoteUI(startTime: 36.0, endTime: 40.0, leafPosition: "fore", isTenuto: true, level: 3),
    NoteUI(startTime: 42.0, endTime: 46.0, leafPosition: "back", isTenuto: true, level: 2),
    NoteUI(startTime: 48.0, endTime: 52.0, leafPosition: "back", isTenuto: true, level: 3),
    
    NoteUI(startTime: 65.0, endTime: 75.0, leafPosition: "left", isTenuto: true, level: 1),
    NoteUI(startTime: 85.0, endTime: 95.0, leafPosition: "left", isTenuto: true, level: 1),
]

var note: Note?
var noteUI: NoteUI?
var noteIterator = 0



struct SwiftUIView: View {
    @AppStorage("neckLength") var neckLength: String = "100"
    @AppStorage("totalLeaves") var totalLeaves: String = "0"
    @ObservedObject var dataModel = DataModel()
    @State var worldName: String = "地面"
//    @State var worldName: String = "云中秘境"  //for testing
    
    @State var isShowInitBlackBackground = true
    @State var isShowIntroVideoView = true
    @State var isInHomePage = false
    @State var isGaming = false
    
    @ObservedObject var scene = GiraffeScene()
    
//    private let cameraNode = createCameraNode()
    
    @ObservedObject var bgmSystem = BgmSystem(bgmURL: urlCaterpillarsFly!)
    
        
    
    //show the progress of bgm
    @State var trimEnd: CGFloat = 0.0
    
    @State var isShowPause = false
    @State var isShowCountScoreView = false
//    @State var scoreScale: CGFloat = 1.0
    @State var isShowStage2Reminder = false
    @State var isShowWow = false
    @State var isShowedWow = false
    @State var isShowTaikula = false
    @State var isShowedTaikula = false
    @State var isShowLikeyou = false
    @State var isShowedLikeyou = false
    
    @State var extraLightAdded = false
    @State var isLeafAdded = false
    @State var leafPosition: String = "fore"
    @State var isTenuto = false
    @State var leafLevel: Int = 1
    @State var leafChangingScale = 1.0
    
    
    var body: some View {
        ZStack{
            
            SceneView(
                scene: scene,
                options: [.allowsCameraControl]
            )
                .ignoresSafeArea()
            
            
            if isInHomePage {
                HomePageView(totalLeaves: $totalLeaves, neckLength: $neckLength, worldName: $worldName, scene: scene, dataModel: dataModel, isLeafAdded: $isLeafAdded)
                    .onAppear{
                        bgmSystem.audioPlayer?.prepareToPlay()
//                        soundEffectSystem.prepareToPlay()
                        scene.score = 0
                        
                        if scene.leafNode != nil {  //清空之前的叶子
                            scene.leafNode?.removeFromParentNode()
                        }
                        
                        noteIterator = 0
                        note = notes[noteIterator]  //init note to be notes[0]
                        noteUI = noteUIs[noteIterator]
                        
                        
                        
                        print("addleafnode1")
                        
//                        scene.shouldContact = true
                        scene.physicsWorld.contactDelegate = scene
                    }
                
                
            }
            
            
            
            ZStack {  //gaming view
                
                if isLeafAdded && noteIterator > 0 {
                    leaf1(leafPosition: $leafPosition, leafLevel: $leafLevel, isTenuto: $isTenuto)
                        .scaleEffect(leafChangingScale)
                        .onChange(of: scene.score, perform: { newValue in
                            withAnimation(.easeOut(duration: 0.15)) {
                                leafChangingScale = 1.2
                            }
                            withAnimation(.easeOut(duration: 0.10)) {
                                leafChangingScale = 0.8
                            }
                            
                        })
                    
                    
                        .onAppear() {
                            leafPosition = noteUI!.leafPosition
                            leafLevel = noteUI!.level
                            isTenuto = noteUI!.isTenuto
                        }
                }
                
                if dataModel.isShowFilter15s {
                    Filter15s()
                }
                
                Button {
                    print("pressed pause button")
//                    soundEffectSystem.buttonPlay()
//                    soundEffectSystem.popUpWindowPlay()
                    if let url = Bundle.main.url(forResource: "Overall_ClickButton", withExtension: "mp3") {
                                let player = AVAudioPlayerPool().playerWithURL(url: url)
                                player?.play()
                            }
                    
                    
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
                
                if isShowStage2Reminder {
                    Stage2Remind()
                        .onAppear() {
//                            soundEffectSystem.surprisePlay()
                            if let url = Bundle.main.url(forResource: "surprise", withExtension: "mp3") {
                                let player = AVAudioPlayerPool().playerWithURL(url: url)
                                player?.volume = 0.6
                                player?.play()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.default) {
                                    isShowStage2Reminder = false
                                }
                            }
                        }
                }
                
                if isShowWow == true && isShowedWow == false {
                    Wow()
                        .onAppear() {
//                            soundEffectSystem.wowPlay()
                            if let url = Bundle.main.url(forResource: "surprise", withExtension: "mp3") {
                                let player = AVAudioPlayerPool().playerWithURL(url: url)
                                player?.volume = 0.6
                                player?.play()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                withAnimation(.default) {
                                    isShowWow = false
                                    isShowedWow = true
                                }
                            }
                        }
                }
                
                if isShowTaikula == true && isShowedTaikula == false{
                    Taikula()
                        .onAppear() {
                            if let url = Bundle.main.url(forResource: "surprise", withExtension: "mp3") {
                                let player = AVAudioPlayerPool().playerWithURL(url: url)
                                player?.volume = 0.6
                                player?.play()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                withAnimation(.default) {
                                    isShowTaikula = false
                                    isShowedTaikula = true
                                }
                            }
                        }
                }
                
                if isShowLikeyou == true && isShowedLikeyou == false{
                    Likeyou()
                        .onAppear() {
//                            soundEffectSystem.likeyouPlay()
                            if let url = Bundle.main.url(forResource: "surprise", withExtension: "mp3") {
                                let player = AVAudioPlayerPool().playerWithURL(url: url)
                                player?.volume = 0.6
                                player?.play()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                withAnimation(.default) {
                                    isShowLikeyou = false
                                    isShowedLikeyou = true
                                }
                            }
                        }
                }
                
                
                
                ScorePanView(scene: scene, bgmSystem: bgmSystem, trimEnd: $trimEnd)
                

                
            } // GamingView: zstack of ruling and circle
            .onAppear() {
                bgmSystem.audioPlayer?.volume = 0.3
                print("bgm duration: ", bgmSystem.audioPlayer?.duration)
                
            }
            .onChange(of: scene.score) { newScore in
                if newScore == 1 {                       //game starts
                    trimEnd = 1.0

                    bgmSystem.play()
                    scene.moveCameraNodeAndNeckNodeToGamePosition()
                    isInHomePage = false
                    scene.leafNode?.removeFromParentNode()
                }
                
                if newScore >= 50 {
                    withAnimation(.default) {
                        isShowWow = true
                    }
                    
                }
                
                if newScore >= 100 {
                    withAnimation(.default) {
                        isShowTaikula = true
                    }
                    
                }
                
                if newScore >= 150 {
                    withAnimation(.default) {
                        isShowLikeyou = true
                    }
                    
                }
                
            }
            .onChange(of: bgmSystem.currentTime) { newValue in
                
                if newValue >= 15.0 && extraLightAdded == false {
//                    scene.addExtraLight()
                    extraLightAdded = true
                    print("extra light added")
                    withAnimation(.default) {
                        isShowStage2Reminder = true
                        dataModel.isShowFilter15s = true
                    }
                }
                
                if (newValue > note!.endTime) {
                    //if currentTime is not in the range of current note
                    //then change note to the next one
                    if scene.leafNode != nil {
                        scene.leafNode!.removeFromParentNode()
                        scene.isContacting = false
                        print("removed leaf")
                    }
//                    isShowProgressBar = false
                    print("curtime and note.endtime: ", newValue, note!.endTime)
                    
                    
                    noteIterator += 1
                    note = notes[noteIterator]
                    noteUI = noteUIs[noteIterator]
                    
                    
                    isLeafAdded = false
                }
                
                if newValue > note!.startTime && isLeafAdded == false {
                    if noteIterator > 0 {
                        scene.addLeafNode(xPosition: note!.leafPosition.x, yPosition: note!.leafPosition.y, zPosition: note!.leafPosition.z, level: note!.level, noteUIPosition: noteUI!.leafPosition)
                        isLeafAdded = true
                        
                        print("addleafnode 2")
                        if note!.isTenuto {
//                            isShowProgressBar = true
                        }
                    }
                    
                    
                }
                
                
                if newValue >= bgmSystem.audioPlayer!.duration - 0.2 && scene.score >= 1 {   //when game ends
                    //bgmSystem.stop() will let bgmSystem.audioPlayer!.currentTime turns to 0.0
                    //and if scene.score >= 1 means game once started
                    bgmSystem.stop()
                    isShowCountScoreView = true
                    
                }
            }
            .onChange(of: isShowPause, perform: { newValue in  //when game pauses
                if newValue == true { //show pause
                    bgmSystem.pause()
//                    scene.shouldContact = false
                    scene.isContacting = false
                    scene.physicsWorld.contactDelegate = nil
                } else {  //resume from pause
                    bgmSystem.play()
//                    scene.shouldContact = true //恢复碰撞检测
                    scene.physicsWorld.contactDelegate = scene
                }
            })
            .fullScreenCover(isPresented: $isShowCountScoreView, content: {
                CountScoreView(neckLength: $neckLength, totalLeaves: $totalLeaves, scene: scene, isInHomePage: $isInHomePage)
                    .onAppear(){
                        print("countscoreview appear")
                        bgmSystem.stop()
//                        scene.removeExtraLight()
                        dataModel.isShowFilter15s = false
//                        soundEffectSystem.showCountScoreViewPlay()
                        if let url = Bundle.main.url(forResource: "CountScoreView_onloading", withExtension: "mp3") {
                                    let player = AVAudioPlayerPool().playerWithURL(url: url)
                                    player?.play()
                                }
//                        scene.shouldContact = false
                        scene.isContacting = false
                        scene.physicsWorld.contactDelegate = nil
                        scene.leafNode?.removeFromParentNode()
                        
                    }
                    .onDisappear(){
                        print("countscoreview disappear")
                        isShowCountScoreView = false
                        if Int(neckLength)! >= neckLengthLevel[0] {
                            if dataModel.isShowCorrectingPositionView {
                                dataModel.isShowCorrectingPositionView = false
                                scene.upWorld()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    dataModel.isShowCorrectingPositionView = true
                                }
                            }
                            
                            worldName = "云中秘境"
                        } else {
                            worldName = "地面"
                        }
                        scene.rotateBackNeckNode()
                        
                    }
            })
            .opacity(!isInHomePage ? 1.0 : 0.0)
            
            if isShowInitBlackBackground {
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
            }
            
            

            
        }
        .fullScreenCover(isPresented: $isShowIntroVideoView, content: {
            IntroVideoView()
                .onDisappear(){
                    isShowIntroVideoView = false
                    isInHomePage = true
                    isShowInitBlackBackground = false
                }
            
        })
        
        
        
        
    }
    
//    static func createCameraNode() -> SCNNode {
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        return cameraNode
//    }
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


//记分板得分弹跳效果
struct Bounce: AnimatableModifier {
    let animCount: Int
    var animValue: CGFloat
    var amplitude: CGFloat  // 振幅
    var bouncingTimes: Int
    
    init(animCount: Int, amplitude: CGFloat = 10, bouncingTimes: Int = 3) {
        self.animCount = animCount
        self.animValue = CGFloat(animCount)
        self.amplitude = amplitude
        self.bouncingTimes = bouncingTimes
    }
    
    var animatableData: CGFloat {
        get { animValue }
        set { animValue = newValue }
    }
    
    func body(content: Content) -> some View {
        let t = animValue - CGFloat(animCount)
        let offset: CGFloat = -abs(pow(CGFloat(M_E), -t) * sin(t * .pi * CGFloat(bouncingTimes)) * amplitude)
        return content.offset(y: offset)
    }
}

extension View {
    func bounce(animCount: Int,
                amplitude: CGFloat = 10,
                bouncingTimes: Int = 3) -> some View {
        self.modifier(Bounce(animCount: animCount,
                             amplitude: amplitude,
                             bouncingTimes: bouncingTimes))
    }
}
