//
//  SwiftUIView.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/23.
//

import SwiftUI
import SceneKit

let soundEffectSystem = SoundEffectSystem()

//延音时长统一为4秒，bgm虫儿飞时长58秒
let notes: [Note] = [
    //x 大 屏幕外
    //y 大 屏幕上
    //z 大 屏幕左， x，z和头运动方向一致
    
    Note(startTime: 0.0, endTime: 1.0, leafPosition: SCNVector3(x: 1.5, y: -1.5, z: 0), isTenuto: false, level: 1), //吃掉第一个叶子启动游戏，位置固定在正下方
    
    Note(startTime: 4.0, endTime: 8.0, leafPosition: SCNVector3(x: 0, y: -0.50, z: 2), isTenuto: true, level: 1), //左
    Note(startTime: 10.0, endTime: 14.0, leafPosition: SCNVector3(x: 0, y: -0.5, z: -2), isTenuto: true, level: 2), //右
    Note(startTime: 16.0, endTime: 20.0, leafPosition: SCNVector3(x: 0, y: -0.5, z: 2), isTenuto: true, level: 3), //左
    Note(startTime: 22.0, endTime: 26.0, leafPosition: SCNVector3(x: 0, y: -0.5, z: -2), isTenuto: true, level: 1), //右
    Note(startTime: 30.0, endTime: 34.0, leafPosition: SCNVector3(x: 1.5, y: -0.5, z: 0.5), isTenuto: true, level: 2),  //前
    Note(startTime: 36.0, endTime: 40.0, leafPosition: SCNVector3(x: 1.5, y: -0.5, z: 0.5), isTenuto: true, level: 3),  //前
    Note(startTime: 42.0, endTime: 46.0, leafPosition: SCNVector3(x: -1.5, y: -0.5, z: -0.5), isTenuto: true, level: 1),  //后
    Note(startTime: 48.0, endTime: 52.0, leafPosition: SCNVector3(x: -1.5, y: -0.5, z: -0.5), isTenuto: true, level: 2),  //后
    
    Note(startTime: 65.0, endTime: 75.0, leafPosition: SCNVector3(x: 1.5, y: -1.5, z: -1), isTenuto: true, level: 1)  //最后添加一个开始时间大于歌曲时长的，避免array index out of range
]
var note: Note?
var noteIterator = 0

struct SwiftUIView: View {
    
    @State var isInHomePage = true
    @State var isGaming = false
    
    @ObservedObject var scene = GiraffeScene()
    
//    private let cameraNode = createCameraNode()
    
    @ObservedObject var bgmSystem = BgmSystem(bgmURL: urlCaterpillarsFly!)
    
        
    
    //show the progress of bgm
    @State var trimEnd: CGFloat = 0.0
    
    @State var isShowPause = false
    @State var isShowCountScoreView = false
//    @State var scoreScale: CGFloat = 1.0
    
    @State var extraLightAdded = false
    @State var isLeafAdded = false
    
    @State var isShowProgressBar = false
    @State private var progress: Double = 0.0
    
    
    var body: some View {
        ZStack{
            
            SceneView(scene: scene,  options: [.allowsCameraControl])
                .ignoresSafeArea()
            
            
            if isInHomePage {
                HomePageView(scene: scene)
                    .onAppear{
                        bgmSystem.audioPlayer?.prepareToPlay()
                        soundEffectSystem.prepareToPlay()
                        
                        if scene.leafNode != nil {  //清空之前的叶子
                            scene.leafNode?.removeFromParentNode()
                        }
                        
                        noteIterator = 0
                        note = notes[noteIterator]  //init note to be notes[0]
                        scene.addLeafNode(xPosition: note!.leafPosition.x, yPosition: note!.leafPosition.y, zPosition: note!.leafPosition.z, level: note!.level)
                        
                        print("addleafnode1")
                        
                        scene.shouldContact = true
                        scene.physicsWorld.contactDelegate = scene
                    }
                
                
            }
            
            
            
            ZStack {  //gaming view
                
              
                
                Button {
                    print("pressed pause button")
                    soundEffectSystem.buttonPlay()
                    soundEffectSystem.popUpWindowPlay()
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
                
                ScorePanView(scene: scene, bgmSystem: bgmSystem, trimEnd: $trimEnd)
                
                if isShowProgressBar {
                    VStack{
                        ProgressView(progress: $progress)
                    }
                }

                
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
                }
                
            }
            .onChange(of: bgmSystem.currentTime) { newValue in
                
                if newValue >= 15.0 && extraLightAdded == false {
                    scene.addExtraLight() 
                    extraLightAdded = true
                    print("extra light added")
                }
                
                if (newValue > note!.endTime) {
                    //if currentTime is not in the range of current note
                    //then change note to the next one
                    if scene.leafNode != nil {
                        scene.leafNode!.removeFromParentNode()
                        print("removed leaf")
                    }
                    isShowProgressBar = false
                    print("curtime and note.endtime: ", newValue, note!.endTime)
                    
                    
                    noteIterator += 1
                    note = notes[noteIterator]
                    
                    
                    isLeafAdded = false
                }
                
                if newValue > note!.startTime && isLeafAdded == false {
                    
                    scene.addLeafNode(xPosition: note!.leafPosition.x, yPosition: note!.leafPosition.y, zPosition: note!.leafPosition.z, level: note!.level)
                    isLeafAdded = true
                    
                    print("addleafnode 2")
                    if note!.isTenuto {
                        isShowProgressBar = true
                    }
                    
                }
                
                
                if newValue == 0.0 && scene.score >= 1 {   //when game ends
                    //bgmSystem.stop() will let bgmSystem.audioPlayer!.currentTime turns to 0.0
                    //and if scene.score >= 1 means game once started
                    isShowCountScoreView = true
                    
                }
            }
            .onChange(of: isShowPause, perform: { newValue in  //when game pauses
                if newValue == true { //show pause
                    bgmSystem.pause()
                    scene.shouldContact = false
                } else {  //resume from pause
                    bgmSystem.play()
                    scene.shouldContact = true //恢复碰撞检测
                    scene.physicsWorld.contactDelegate = scene
                }
            })
            .fullScreenCover(isPresented: $isShowCountScoreView, content: {
                CountScoreView(scene: scene, isInHomePage: $isInHomePage)
                    .onAppear(){
                        print("countscoreview appear")
                        bgmSystem.stop()
                        soundEffectSystem.showCountScoreViewPlay()
                        scene.shouldContact = false
                        
                    }
                    .onDisappear(){
                        print("countscoreview disappear")
                        isShowCountScoreView = false
                    }
            })
            .opacity(!isInHomePage ? 1.0 : 0.0)
            
            
            

            
        }
        
        
        
        
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
