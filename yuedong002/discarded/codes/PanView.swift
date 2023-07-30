//import SwiftUI
//import AVFoundation
//
//struct PanView: View {
//    @State private var panValue: Double = 0.0
//    var audioPlayer: AVAudioPlayer?
//
//    var body: some View {
//        VStack {
//            Text("Audio Spatialization")
//                .font(.headline)
//
//            Slider(value: $panValue, in: -1.0...1.0, step: 0.01)
//                .padding()
//
//            Button(action: {
//                playAudioWithSpatialization()
//            }) {
//                Text("Play Audio")
//            }
//        }
//        .padding()
//    }
//
//    func playAudioWithSpatialization() {
//        guard let audioURL = Bundle.main.url(forResource: "moonriver", withExtension: "mp3") else {
//            print("Audio file load error")
//            return
//        }
//
//        let audioEngine = AVAudioEngine()
//        let audioPlayerNode = AVAudioPlayerNode()
//        audioEngine.attach(audioPlayerNode)
//
//        let audioFile = try? AVAudioFile(forReading: audioURL)
//        let format = audioFile?.processingFormat
//
//        // Create an AVAudioUnitPanner for spatialization
//        let panner = AVAudioUnitPanner()
//        audioEngine.attach(panner)
//
//        // Connect nodes in the audio engine
//        audioEngine.connect(audioPlayerNode, to: panner, format: format)
//        audioEngine.connect(panner, to: audioEngine.mainMixerNode, format: format)
//
//        // Set the pan value based on the slider's value
//        panner.pan = Float(panValue)
//
//        do {
//            try audioEngine.start()
//            audioPlayerNode.scheduleFile(audioFile!, at: nil, completionHandler: nil)
//            audioPlayerNode.play()
//        } catch {
//            print("Error starting audio engine: \(error.localizedDescription)")
//        }
//    }
//}
//
//struct PanView_Previews: PreviewProvider {
//    static var previews: some View {
//        PanView()
//    }
//}
