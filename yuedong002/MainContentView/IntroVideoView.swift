//
//  IntroVideoView.swift
//  yuedong002
//
//  Created by Jzh on 2023/8/18.
//

import SwiftUI
import AVKit


struct IntroVideoView: View {
    @Binding var isShowIntroVideoView: Bool
    @Environment(\.presentationMode) var presentationMode //used to close this sheet view
    
    @State var player = AVPlayer(url: Bundle.main.url(forResource: "引导页_4", withExtension: "mp4")!)
    @State var currentTime = 0.0
    @State var timer: Timer?
    @State var isAddButton: Bool = false
    
    
    var body: some View {
        ZStack( alignment: .center) {
            
            
            
            VideoPlayer(player: player) {
                // You can add video controls or other customizations here
            }
            .edgesIgnoringSafeArea(.all)
            .scaledToFill()
            .onTapGesture {
                
            }
            
            .onAppear {
                player.play()
                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                    currentTime = player.currentTime().seconds
                    print(Double(currentTime))
                }
                currentTime = player.currentTime().seconds
                
                print(Double(currentTime))
            }
            .onDisappear() {
                timer?.invalidate()
            }
            .onChange(of: currentTime) { newValue in
                if newValue >= 14.0 {
                    isAddButton = true
                }
            }
            
            VStack{
                Rectangle() // above videoplayer layer to prevent touch to show player controller
                    .foregroundColor(.green)
                    .opacity(0.05)
    //                .ignoresSafeArea()
                    .edgesIgnoringSafeArea(.all)
            }
            .edgesIgnoringSafeArea(.all)

            
            
            
            if isAddButton {
                VStack {
                    Spacer()
                    
                    Button(action: {
                        print("button pressed")
                        withAnimation {
                            isShowIntroVideoView = false
                        }
                        
                        
                        presentationMode.wrappedValue.dismiss()  //close this sheet view
                    }, label: {
                        Text("冲!")
                          .font(Font.custom("DFPYuanW9-GB", size: 20))
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 1, green: 1, blue: 1))
                          .opacity(0.7)
                    })
                    .padding(.bottom, 90)
                    .padding(.trailing, 30)
                }
            }
            
            
            
        }
    }
}

struct IntroVideoView_Previews: PreviewProvider {
    static var previews: some View {
        IntroVideoView(isShowIntroVideoView: .constant(true))
    }
}
