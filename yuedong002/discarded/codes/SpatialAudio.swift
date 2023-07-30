import Foundation
import AVFoundation
import CoreMotion

class SpatialAudioPlayer: ObservableObject {
    var audioEngine: AVAudioEngine?
    var audioPlayerNode: AVAudioPlayerNode?
    var audioEnvironmentNode: AVAudioEnvironmentNode?
    var audioFile: AVAudioFile?
    
    init() {
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioEnvironmentNode = AVAudioEnvironmentNode()
        setSoundEffectFile(fileName: "pianoA")
        
        if let audioEngine = audioEngine, let audioPlayerNode = audioPlayerNode, let audioEnvironmentNode = audioEnvironmentNode {
            audioEngine.attach(audioPlayerNode)
            audioEngine.attach(audioEnvironmentNode)
            
            audioEngine.connect(audioPlayerNode, to: audioEnvironmentNode, format: audioFile?.processingFormat)
            let outputNode = audioEngine.outputNode
            audioEngine.connect(audioEnvironmentNode, to: outputNode, format: audioFile?.processingFormat)
            
            do {
                try audioEngine.start()
            } catch {
                print("Failed to start audio engine: \(error.localizedDescription)")
            }
        }
    }
    
    // Set the audio file for the sound effect
    func setSoundEffectFile(fileName: String) {
        if let audioURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            do {
                audioFile = try AVAudioFile(forReading: audioURL)
            } catch {
                print("Failed to load audio file: \(error.localizedDescription)")
            }
        }
    }
    
    func setListenerPosition(x: Float, y: Float, z: Float) {
        if let audioEnvironmentNode = audioEnvironmentNode {
            let position = AVAudio3DPoint(x: x, y: y, z: z)
            audioEnvironmentNode.listenerPosition = position
        }
    }
    
    func playAudio(at position: AVAudio3DPoint) {
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.position = position
            audioPlayerNode.play()
        }
    }
    
    // 设置音频空间化属性
    func setAudioSpatialization(enable: Bool) {
        if let audioEnvironmentNode = audioEnvironmentNode {
            audioEnvironmentNode.renderingAlgorithm = enable ? .HRTF : .stereoPassThrough
        }
    }
}
