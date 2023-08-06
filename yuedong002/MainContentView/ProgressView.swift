//
//  ProgressView.swift
//  yuedong002
//
//  Created by Jzh on 2023/8/6.
//

import SwiftUI

struct ProgressView: View {
    @Binding var progress: Double // The current progress value
    let totalTime: TimeInterval = 4.0 // The total time for the progress bar (4 seconds in this example)
    let timerInterval: TimeInterval = 0.1 // The interval to update the progress value (adjust for smoother animation)

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 22) // The base track of the progress bar
                        .frame(width: geometry.size.width * 0.6, height: 10)
                        .foregroundColor(Color(red: 0.88, green: 1, blue: 0.8))
                    
                    RoundedRectangle(cornerRadius: 22) // The animated progress bar
                        .frame(width: geometry.size.width * 0.6 * progress, height: 10)
                        .foregroundColor(Color(red: 0.43, green: 0.65, blue: 0.3))
                        .animation(.linear(duration: 4.0)) // Animate the progress bar
                }
            }
            Spacer()
            .onAppear {
//                startTimer()
                withAnimation(.linear(duration: 4.0)) {
                    progress = 1.0
                }
                
            }
            .onDisappear() {
                progress = 0.0
            }
        }
        .offset(x:80, y:600)
        
        
    }

//    // Start the timer to update the progress value
//    private func startTimer() {
//        let timer = Timer(timeInterval: timerInterval, repeats: true) { _ in
//            updateProgress()
//        }
//        RunLoop.current.add(timer, forMode: .common)
//    }
//
//    // Update the progress value
//    private func updateProgress() {
//        guard progress < 1.0 else {
//            return
//        }
//        progress += CGFloat(timerInterval / totalTime)
//    }
    
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(progress: .constant(0.5))
    }
}
