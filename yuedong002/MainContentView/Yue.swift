////
////  Yue.swift
////  yuedong002
////
////  Created by Jzh on 2023/7/21.
////
//
//import SwiftUI
//
//struct Yue: View {
//    // 创建 SpatialMusicPlayer 的实例
//    let spatialMusicPlayer: SpatialMusicPlayer = SpatialMusicPlayer()
//
//
//
//    var body: some View {
//        VStack {
//            Button(action: {
//
//                spatialMusicPlayer.setAudioFile(fileName: "monoMoonriver")
//
//
//
//                // 启用音频空间化效果
////                spatialMusicPlayer.setAudioSpatialization(enable: true)
//
//                //listener position
//                spatialMusicPlayer.setListenerPosition(x: 0, y: 0, z: 0)
//
//                // 设置音频的位置
////                spatialMusicPlayer.setAudioPosition(x: 0, y: 0, z: -1)
//                spatialMusicPlayer.playAudio()
//            }) {
//                Image(systemName: "play.fill")
//                    .font(.system(size: 60))
////                    .foregroundColor(.white)
//            }
//
//            HStack{
//                Button(action: {
//                    spatialMusicPlayer.setAudioPosition(x: -1, y: 0, z: 0) // 音频在左侧
//                }) {
//                    Image(systemName: "arrow.left")
//                        .font(.system(size: 60))
////                        .foregroundColor(.white)
//                }
//                Button(action: {
//                    spatialMusicPlayer.setAudioPosition(x: 1, y: 0, z: 0)  // 音频在右侧
//                }) {
//                    Image(systemName: "arrow.right")
//                        .font(.system(size: 60))
////                        .foregroundColor(.white)
//                }
//                Button(action: {
//                    spatialMusicPlayer.setAudioPosition(x: 0, y: 0, z: -1)
//                }) {
//                    Image(systemName: "arrow.up")
//                        .font(.system(size: 60))
////                        .foregroundColor(.white)
//                }
//                Button(action: {
//                    spatialMusicPlayer.setAudioPosition(x: 0, y: 0, z: 1)
//                }) {
//                    Image(systemName: "arrow.down")
//                        .font(.system(size: 60))
////                        .foregroundColor(.white)
//                }
//            } //hstack end
//
//            Button(action: {
//                spatialMusicPlayer.stopAudio()
//            }) {
//                Image(systemName: "stop.fill")
//                    .font(.system(size: 60))
////                    .foregroundColor(.white)
//            }
//
//        } //vstack end
//        .onAppear {
//
//        }
//    }
//}
//
//struct Yue_Previews: PreviewProvider {
//    static var previews: some View {
//        Yue()
//    }
//}
//
