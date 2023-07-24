//
//  GameBoard.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/23.
//

import SwiftUI

struct GameBoard: View {
    @State private var isAnimalVisible = false

    
    

    @State private var personPosition: CGPoint = .zero
    @State private var animalPosition: CGPoint = .zero

        var body: some View {
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)

                ZStack {
//                    Text("点击动物使其消失")

                    Image("RabbitEyesClosedEllipse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)

                    if isAnimalVisible {
                        AnimalView()
                    }
                }
                .onAppear {
                    // 每隔一段时间显示动物
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                        isAnimalVisible = true
                    }
                }
                .onTapGesture {
                    // 点击动物后使其消失
                    isAnimalVisible = false
                }
            }
        }
}


struct AnimalView: View {
    @ObservedObject var midiPlaySystem = MidiPlaySystem()
    @State var pitchToPlay = UInt8(60)

    let animalCoordinates: [[(CGPoint, Int8)]] = [
        
        
        [(CGPoint(x: 200, y: 250), 60)],
        [(CGPoint(x: 300, y: 250), 62)],
        [(CGPoint(x: 300, y: 400), 64)],
        [(CGPoint(x: 300, y: 550), 65)],
        [(CGPoint(x: 200, y: 550), 67)],
        [(CGPoint(x: 100, y: 550), 69)],
        [(CGPoint(x: 100, y: 400), 71)],
        [(CGPoint(x: 100, y: 250), 72)],
        
//        [(CGPoint(x: 200, y: 400), 72)]
        
        
        

//        CGPoint(x: 230, y: 450),
        
        

        
        
        
    ]

    @State private var animalPosition = CGPoint.zero

    var body: some View {
        Image(systemName: "tortoise.fill")
            .resizable()
            .frame(width: 80, height: 80)
            .position(animalPosition)
            .onAppear {
                // 设置随机坐标
//                animalPosition = animalCoordinates.randomElement()?? .zero .0
//                pitchToPlay = animalCoordinates.randomElement()?? .zero .1
                
                if let randomAnimalCoordinate = animalCoordinates.randomElement() {
                    // 使用随机取出的 CGPoint 坐标
                    animalPosition = randomAnimalCoordinate[0].0
                    
                    print("随机取出的 CGPoint: \(animalPosition)")
                    
                    // 使用随机取出的 Int8 音符
                    pitchToPlay = UInt8(randomAnimalCoordinate[0].1)
                    print("随机取出的 Midi Note: \(pitchToPlay)")
                } else {
                    print("数组为空，无法取出随机元素")
                }
                
                // 播放音符
                var velocity = UInt8(150)     // to correct with motion
                midiPlaySystem.playNoteWithPitch(pitch: pitchToPlay, velocity: velocity)

            }
    }
}


struct GameBoard_Previews: PreviewProvider {
    static var previews: some View {
        GameBoard()
            .previewDevice(.init(rawValue: "iPhone 13 mini"))
    }
}



//import SwiftUI
//import AVFAudio
//
//struct GameBoard: View {
//    @StateObject private var audioPlayer = SpatialAudioPlayer()
//
//
//    @State private var personPosition: CGPoint = .zero
//    @State private var animalPosition: CGPoint = .zero
//
//    private let animalCoordinates: [CGPoint] = [
////                CGPoint(x: 100, y: 250),
////                CGPoint(x: 100, y: 450),
////                CGPoint(x: 100, y: 650),
//
//                CGPoint(x: 230, y: 400),
//        //        CGPoint(x: 230, y: 450),
//                CGPoint(x: 230, y: 500),
//
////                CGPoint(x: 310, y: 250),
////                CGPoint(x: 310, y: 450),
////                CGPoint(x: 310, y: 650),
//        // Add more preset coordinates as needed
//    ]
//
//    var body: some View {
//        ZStack {
//            Color.white
//                .ignoresSafeArea()
//
//            Image("RabbitEyesClosedEllipse")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 50, height: 50)
//                .position(personPosition)
//
//            Image("RabbitEyesClosedEllipse")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 50, height: 50)
//                .position(animalPosition)
//                .onTapGesture {
//                    animalTapped()
//                }
//        }
//        .onAppear {
//            setRandomPositions()
//            audioPlayer.setSoundEffectFile(fileName: "pianoA")
//            audioPlayer.setAudioSpatialization(enable: true)
//            audioPlayer.setListenerPosition(x: Float(personPosition.x), y: Float(personPosition.y), z: 0)
//        }
//        .onChange(of: animalPosition) { newValue in
//            do {
//                let session = AVAudioSession.sharedInstance()
//                try session.setCategory(.playback, mode: .default)
//                try session.setActive(true)
//                print("setting session")
//            } catch {
//                print("设置音频会话失败：\(error.localizedDescription)")
//            }
//
//
//            audioPlayer.playAudio(at: AVAudio3DPoint(x: Float(newValue.x), y: Float(newValue.y), z: 0))
//
//        }
//
//    }
//
//    func setRandomPositions() {
//        personPosition = CGPoint(x: 230, y: 450) // Set the initial position of the person view
//
//        // Set a random position for the animal
//        animalPosition = animalCoordinates.randomElement() ?? .zero
//        audioPlayer.playAudio(at: AVAudio3DPoint(x: Float(animalPosition.x), y: Float(animalPosition.y), z: 0))
//    }
//
//    func animalTapped() {
//        // Handle the tap event when the animal is tapped
//        setRandomPositions()
//    }
//}
