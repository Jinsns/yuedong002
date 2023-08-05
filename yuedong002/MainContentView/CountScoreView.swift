//
//  CountScoreView.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/27.
//

import SwiftUI

struct CountScoreView: View {
//    @Binding var finalScore: Int
    @ObservedObject var scene: GiraffeScene
    
    @Binding var isInHomePage: Bool
    
    
    @State private var isScorePanSizeSwitching = false
    @State var scoreScale: CGFloat = 1.0
    
    @Environment(\.presentationMode) var presentationMode //used to close this sheet view
    
    
    
    
    
    var body: some View {
        ZStack{
            Image("songEnd")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
//                .padding(.horizontal, 14)
//                .padding(.trailing, 10)
            
            
            
            ZStack {

                        
                VStack {
                    Image("leaf")
                        .foregroundColor(.white)
                        .scaledToFit()
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(width: 40)
                        .offset(x: 0, y: 6)
                        .padding(.top, 20)
 
                    Text(" + \(scene.score)")
                        .foregroundColor(.green)
                        .font(.headline)
                        .offset(x: 0, y: -16)
                        .padding(.bottom, 20)
                }  //VStack of white circle containing a leaf and +finalScore
                .background(
                    Circle()
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .frame(width: 90, height: 90)
                )
                .scaleEffect(scoreScale)
                .offset(x: 110, y:-100)
                .onAppear {
                    isScorePanSizeSwitching.toggle()
                    
                }
                .onChange(of: isScorePanSizeSwitching) { newValue in
                    withAnimation(.easeOut(duration: 0.5)) {
                        scoreScale = 1.2
                    }
                    withAnimation(.easeOut(duration: 0.3).delay(0.5)) {
                        scoreScale = 0.8
                    }
                    withAnimation(.easeOut(duration: 0.2).delay(0.8)) {
                        scoreScale = 1.0
                    }
                }
                
            }
            
            
            
            
            
            
            VStack(spacing: 60){
                Spacer()
                VStack(alignment: .center, spacing: 23) {
                    Text("哦哦～脖子长度+\(Int(scene.score / 5))cm")
                        .font(Font.custom("DFPYuanW9-GB", size: 25.05524))
                        .kerning(0.5011)
                        .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                    Text("现在我有128cm长的脖子\n可以看到日出风景啦")
                      .font(Font.custom("DFPYuanW7-GB", size: 16))
                      .kerning(0.64)
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                      .frame(width: 192, alignment: .center)
                      .lineSpacing(5)   //调整行间距
                } //text VStack
                
                
                
                HStack(alignment: .center, spacing: 0) {
                    Button {
                        print("want to go back to main page")
                        soundEffectSystem.buttonPlay()
                        scene.score = 0        
                        isInHomePage = true
                        
                        presentationMode.wrappedValue.dismiss()  //close this sheet view
                        
                    } label: {
                        Text("返回主页")
                            .font(Font.custom("DFPYuanW9-GB", size: 17))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                }
                .padding(.leading, 29)
                .padding(.trailing, 30)
                .padding(.vertical, 11)
                .background(Color(red: 0.41, green: 0.63, blue: 0.16))
                .cornerRadius(7)
                .padding(.bottom, 100)

            }
                        
            
            
            
           
        }

    }
}

struct CountScoreView_Previews: PreviewProvider {
    static var previews: some View {
        CountScoreView(scene: GiraffeScene(), isInHomePage: .constant(false))
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


