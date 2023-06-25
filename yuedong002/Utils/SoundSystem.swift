//
//  SoundSystem.swift
//  yuedong001
//
//  Created by Jzh on 2023/6/8.
//

import SwiftUI
import AVFoundation
import CoreMotion

//let pathC = Bundle.main.path(forResource: "pianoC", ofType: "mp3")!
//let pathD = Bundle.main.path(forResource: "pianoD", ofType: "mp3")!
//let pathE = Bundle.main.path(forResource: "pianoE", ofType: "mp3")!
//let pathF = Bundle.main.path(forResource: "pianoF", ofType: "mp3")!
//let urlC = URL(fileURLWithPath: pathC)
//let urlD = URL(fileURLWithPath: pathD)
//let urlE = URL(fileURLWithPath: pathE)
//let urlF = URL(fileURLWithPath: pathF)
class SoundSystem: UIViewController {
    var audioPlayer: AVAudioPlayer?
    
    func play(soundUrl: URL) {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            self.audioPlayer?.play()
        } catch {
            print("error when playing")
        }
    }
    
    func stop() {
        self.audioPlayer?.stop()
    }
    
    func getCurrentTime() -> Double {
        return Double(self.audioPlayer?.currentTime ?? 0.0)
    }
    
    
    
}


class BgmSystem {
    var audioPlayer: AVAudioPlayer?
    var isPlaying = false
    
    func play(soundUrl: URL) {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            self.audioPlayer?.play()
        } catch {
            print("error when playing bgm")
        }
    }
    
    func stop() {
        self.audioPlayer?.stop()
        self.audioPlayer?.currentTime = 0
        self.isPlaying = false
    }
    
}


class MidiPlaySystem: ObservableObject{
    @Published var isRecording: Bool
    let engine: AVAudioEngine
    let sampler: AVAudioUnitSampler
    var audioFileURL: URL
    var recordingTimer: Timer? // 录音计时器
        
    @Published var recordingDuration: TimeInterval = 0 // 录音持续时间
    
    init() {
        isRecording = false
        engine = AVAudioEngine()
        sampler = AVAudioUnitSampler()
        audioFileURL = URL(string: "recording.wav")!
        setupAudioEngine()
        
    }
    
    func setupAudioEngine() {
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        
        let soundbank = Bundle.main.path(forResource: "gs_instruments", ofType: "dls")!
        let soundbankURL = URL(fileURLWithPath:soundbank)
        let melodicBank:UInt8 = UInt8(kAUSampler_DefaultMelodicBankMSB)
        let gmHarpsichord:UInt8 = 6
        
        
        
        do {
            try engine.start()
            try sampler.loadSoundBankInstrument(at: soundbankURL, program: gmHarpsichord, bankMSB: melodicBank, bankLSB: 0)
        } catch {
            print("无法启动 audio engine: \(error.localizedDescription)")
        }
    }
    
    func playNoteWithPitch(pitch: UInt8, velocity: UInt8) {
        sampler.startNote(pitch, withVelocity: velocity, onChannel: 0)
    }
    
    func stopNoteWithPitch(pitch: UInt8) {
        sampler.stopNote(pitch, onChannel: 0)
    }
    
    func startRecording(filename: String) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let audioFileURL = documentDirectory.appendingPathComponent(filename)
        
        isRecording = true
        
        recordingDuration = 0
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
                    self?.recordingDuration += 1
                    // 在这里可以执行与录音持续时间相关的操作，比如更新UI显示
                }
        
        do {
            
            let buffer = AVAudioPCMBuffer(pcmFormat: engine.mainMixerNode.outputFormat(forBus: 0), frameCapacity: AVAudioFrameCount(engine.outputNode.outputFormat(forBus: 0).sampleRate))!
            
            // recording path to be customized
//            audioFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recording.wav")
            self.audioFileURL = audioFileURL
            let audioFile = try AVAudioFile(forWriting: audioFileURL, settings: buffer.format.settings)
            
            engine.mainMixerNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(buffer.frameCapacity), format: engine.mainMixerNode.outputFormat(forBus: 0)) { (buffer, time) in
                do {
                    try audioFile.write(from: buffer)
                } catch {
                    print("无法写入音频文件: \(error.localizedDescription)")
                }
            }
            
        } catch {
            print("无法开始录制: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        isRecording = false
        
        recordingTimer?.invalidate()
        recordingTimer = nil
        
        engine.mainMixerNode.removeTap(onBus: 0)
        engine.stop()
        
        print("录制完成，音频文件保存在: \(audioFileURL)")
    }
    
}


//class AudioEngine {
//    func initAudio(){
//
//        let engine = AVAudioEngine()
//        let sampler = AVAudioUnitSampler()
//
//        engine.attach(sampler)
//        engine.connect(sampler, to: engine.outputNode, format: nil)
//
//        guard let soundbank = Bundle.main.path(forResource: "gs_instruments", ofType: "dls")! else {
//
//            print("Could not initalize soundbank.")
//            return
//        }
//        let soundbankURL = URL(fileURLWithPath:soundbank)
//        let melodicBank:UInt8 = UInt8(kAUSampler_DefaultMelodicBankMSB)
//        let gmHarpsichord:UInt8 = 6
//        do {
//            try engine.start()
//            try self.sampler?.loadSoundBankInstrumentAtURL(bankURL: soundbankURL, program: gmHarpsichord, bankMSB: melodicBank, bankLSB: 0)(soundbank, program: gmHarpsichord, bankMSB: melodicBank, bankLSB: 0)
//
//        }catch {
//            print("An error occurred \(error)")
//            return
//        }
//
//        self.sampler!.startNote(60, withVelocity: 64, onChannel: 0)
//    }
//}


import SwiftUI
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    
    
}





