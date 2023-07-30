//
//  createmode.swift
//  yuedong001
//
//  Created by Jzh on 2023/6/21.
//


import SwiftUI
import AVFoundation


struct CreateMode: View {
    let motionManager = MotionManager()
    @ObservedObject var midiPlaySystem = MidiPlaySystem()
    let downloader = Downloader()
    let bgmSystem = BgmSystem(bgmURL: urlSpatialMoonRiver)
    let uploader = Uploader()
    
    @State var topBackward = false
    @State var topForward = false
    @State var antiClock = false
    @State var clockWise = false
    
    @State var isRecording = false
    @State var isPlayingNote = false
    @State var pitchToPlay = UInt8(60)
    
    @State var username = "Bob"
    @State var musicDescription = "Happy rock"
    @State var fileURLs: [URL] = []

    
    
    var body: some View {
        VStack {
            Button(action: {
                isRecording.toggle()
                let recordFileName = "UserRecord.wav"
                if isRecording {
                    midiPlaySystem.startRecording(filename: recordFileName)
                } else {
                    midiPlaySystem.stopRecording()
                }
            }, label: {
                Text(isRecording ? "Stop recording" : "Play and Start Recording" )
            })
            
            DownloaderView(downloader: downloader, username: $username, fileURLs: $fileURLs)
                .onAppear{
                    fileURLs = getFileURLs()
                }
            
            VStack {
                List(fileURLs, id: \.self) { fileURL in
//                    FileItem(fileURL: fileURL, fileURLs: fileURLs, bgmSystem: bgmSystem, uploader: uploader, username: $username, musicDescription: $musicDescription)
                    FileItem(fileURL: fileURL, bgmSystem: bgmSystem, uploader: uploader, username: $username, musicDescription: $musicDescription, fileURLs: $fileURLs)
                }
            }
            .onAppear{
                fileURLs = getFileURLs()
            }
            
            
            MotionStateView(motionManager: motionManager, topBackward: $topBackward, topForward: $topForward, antiClock: $antiClock, clockWise: $clockWise)
                .onAppear{
                    midiPlaySystem.setupAudioEngine()
                }
                .onChange(of: midiPlaySystem.recordingDuration, perform: { _ in
                    if motionManager.pitch > 3.14 / 6 {
                        topForward = true
                        pitchToPlay = 60
                    } else {
                        topForward = false
                    }
                    
                    if motionManager.pitch < -3.14 / 6 {
                        topBackward = true
                        pitchToPlay = 64
                    } else {
                        topBackward = false
                    }
                    
                    if motionManager.roll > 3.14 / 6 {
                        clockWise = true
                        pitchToPlay = 67
                    } else {
                        clockWise = false
                    }
                    
                    if motionManager.roll < -3.14 / 6 {
                        antiClock = true
                        pitchToPlay = 71
                    } else {
                        antiClock = false
                    }
                    
                    if abs(motionManager.pitch) > 3.14 / 6 || abs(motionManager.roll) > 3.14 / 6 {
                        isPlayingNote = true
                        
                    } else {
                        isPlayingNote = false
                    }
                    
                }
                    
                
                )  //MotionStateView onChange1 Over
                .onChange(of: isPlayingNote){ newIsPlayingNote in
                    if newIsPlayingNote {
                        var velocity = UInt8(150)     // to correct with motion
                        midiPlaySystem.playNoteWithPitch(pitch: pitchToPlay, velocity: velocity)
                    }
                    
                }
        }
        .navigationTitle("Create Mode")
        
    }
}



