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


class BgmSystem: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    var isPlaying: Bool
    var duration: Double
    @Published var currentTime: Double = 0.0
    
    
    
    init(bgmURL: URL) {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: bgmURL)
        } catch {
            print("error when playing bgm")
        }
        
        self.isPlaying = false
        self.duration = audioPlayer?.duration ?? 3.0
    }
    
    
    func play() {
        if self.isPlaying == false {
            self.isPlaying = true
            self.audioPlayer?.play()
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if self.isPlaying == true {
                self.currentTime = self.audioPlayer!.currentTime  //之后的更新时间
                //                    print("change currentTime to ", self.currentTime)
            }
            
        }
    }
    
    func pause() {
        self.isPlaying = false
        self.audioPlayer?.pause()
        print("paused")
    
    }
    
    func stop() {
        self.isPlaying = false
        self.audioPlayer?.stop()
        self.audioPlayer?.currentTime = 0.0
        
        print("stopped")
    }
    
}

class SoundEffectSystem {
    
    var buttonAudioPlayer: AVAudioPlayer?
    var showCountScoreViewAudioPlayer: AVAudioPlayer?
    var overallDialogAudioPlayer: AVAudioPlayer?
    var popUpWindowAudioPlayer: AVAudioPlayer?
    
    var wowAudioPlayer: AVAudioPlayer?
    var taikulaAudioPlayer: AVAudioPlayer?
    var likeyouAudioPlayer: AVAudioPlayer?
    var surpriseAudioPlayer: AVAudioPlayer?
    
    init() {
//        let buttonSoundFileName = "Overall_ClickButton"
//        let showCountScoreViewSoundFileName = "CountScoreView_onloading"
//        let overallDialogSoundFileName = "Overall_Dialog"
        
        let buttonSoundURL = Bundle.main.url(forResource: "Overall_ClickButton", withExtension: "mp3")!
        let showCountScoreViewSoundURL = Bundle.main.url(forResource: "CountScoreView_onloading", withExtension: "mp3")!
        let overallDialogSoundURL = Bundle.main.url(forResource: "Overall_Dialog", withExtension: "mp3")!
        let popUpWindowSoundURL = Bundle.main.url(forResource: "PopupWindow", withExtension: "mp3")!
        let wowSound = Bundle.main.url(forResource: "1-wow", withExtension: "mp3")!
        let taikulaSound = Bundle.main.url(forResource: "2-cool", withExtension: "mp3")!
        let likeyouSound = Bundle.main.url(forResource: "3-ShenShou", withExtension: "mp3")!
        let surpriseSound = Bundle.main.url(forResource: "surprise", withExtension: "mp3")!
        
        do {
            self.buttonAudioPlayer = try AVAudioPlayer(contentsOf: buttonSoundURL)
            self.showCountScoreViewAudioPlayer = try AVAudioPlayer(contentsOf: showCountScoreViewSoundURL)
            self.overallDialogAudioPlayer = try AVAudioPlayer(contentsOf: overallDialogSoundURL)
            self.popUpWindowAudioPlayer = try AVAudioPlayer(contentsOf: popUpWindowSoundURL)
            
            self.wowAudioPlayer = try AVAudioPlayer(contentsOf: wowSound)
            self.taikulaAudioPlayer = try AVAudioPlayer(contentsOf: taikulaSound)
            self.likeyouAudioPlayer = try AVAudioPlayer(contentsOf: likeyouSound)
            self.surpriseAudioPlayer = try AVAudioPlayer(contentsOf: surpriseSound)
            
        } catch {
            print("error when initializing audioplayer")
            print("Error initializing buttonAudioPlayer: \(error.localizedDescription)")
        }
        
        
    }
    
    func prepareToPlay() {
        self.buttonAudioPlayer?.prepareToPlay()
        self.showCountScoreViewAudioPlayer?.prepareToPlay()
        self.overallDialogAudioPlayer?.prepareToPlay()
        self.popUpWindowAudioPlayer?.prepareToPlay()
        
        self.wowAudioPlayer?.prepareToPlay()
        self.taikulaAudioPlayer?.prepareToPlay()
        self.likeyouAudioPlayer?.prepareToPlay()
        self.surpriseAudioPlayer?.prepareToPlay()
        
    }
    
    func buttonPlay() {
        self.buttonAudioPlayer?.play()
    }
    
    func showCountScoreViewPlay() {
        self.showCountScoreViewAudioPlayer?.play()
    }
    
    func overallDialogPlay() {
        self.overallDialogAudioPlayer?.play()
    }
    
    func popUpWindowPlay() {
        self.popUpWindowAudioPlayer?.play()
        print("popUpWindowPlayed")
        
    }
    
    func wowPlay() {
        self.wowAudioPlayer?.volume = 4.0
        self.wowAudioPlayer?.play()
    }
    
    func taikulaPlay() {
        self.taikulaAudioPlayer?.volume = 4.0
        
        self.taikulaAudioPlayer?.play()
    }
    
    func likeyouPlay() {
        self.likeyouAudioPlayer?.volume = 4.0
        self.likeyouAudioPlayer?.play()
    }
    
    func surprisePlay() {
        self.surpriseAudioPlayer?.volume = 4.0
        self.surpriseAudioPlayer?.play()
    }
    
    
    
    
    
}

private var players:[AVAudioPlayer] = []

class AVAudioPlayerPool: NSObject {
    

    //指定声音文件URL，有空闲重用，没空闲创建AVAudioPlayer
    func playerWithURL(url:URL) -> AVAudioPlayer? {
        
        //查找一个空闲的AVAudioPlayer
        let availabelPlayers = players.filter { (player) -> Bool in
            return player.isPlaying == false && player.url == url
        }
        
        //如果找到，返回AVAudioPlayer对象
        if let playerToUse = availabelPlayers.first{
            return playerToUse
        }
        
        //没有找到，新建一个AVAudioPlayer对象
        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            players.append(newPlayer)
            return newPlayer
        } catch {
            print(error)
        }
        return nil
    }
}










//MidePlaySystem is used in create mode
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











