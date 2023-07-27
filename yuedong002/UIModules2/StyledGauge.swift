import SwiftUI

struct GaugeStyleView: View {
    
    @ObservedObject var bgmSystem = BgmSystem(bgmURL: urlSpatialMoonRiver)
    @State private var currentTime = 0.0
    private let minTime = 0.0
//    private let maxTime: Double  // bgmSystem.audioPlayer.duration
    
    
    
   
    

      var body: some View {
          
          VStack{
              Gauge(value: bgmSystem.currentTime, in: minTime...bgmSystem.audioPlayer!.duration) {
                  Text("\(Int(bgmSystem.currentTime))")
              }
              .gaugeStyle(.accessoryCircularCapacity)
              
              Button("Play Music") {
                  bgmSystem.play() // Function to play background music
              }
              .padding()
              
              Button {
                  bgmSystem.pause()
              } label: {
                  Text("pause")
              }
              
              Button {
                  bgmSystem.stop()
              } label: {
                  Text("pause")
              }

          }
        
          
      
      }
}


struct GaugeStyleView_Previews: PreviewProvider {
    static var previews: some View {
        GaugeStyleView()
    }
}

