//
//  CountScoreView.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/27.
//

import SwiftUI

struct CountScoreView: View {
    @Binding var neckLength: String
    @State var dNeckLength: Int = 0
    @Binding var totalLeaves: String
    @State var dLeaves: Int = 1443
//    @Binding var finalScore: Int
    @ObservedObject var scene: GiraffeScene
    
    @Binding var isInHomePage: Bool
    
    
    @State private var isScorePanSizeSwitching = false
    @State var scoreScale: CGFloat = 1.0
    @State var giraffeDHeight = 0.0
    
    @Environment(\.presentationMode) var presentationMode //used to close this sheet view
    
    
    
    
    
    var body: some View {
        ZStack{
            
            
            Image("songEndBG2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
//                .padding(.horizontal, 14)
//                .padding(.trailing, 10)
            
            ZStack(alignment: .centerFirstTextBaseline) {
                Image("songEndCircle")
                    .padding(.bottom, 160)
                Image("SongEndGiraffe")
                    .offset(x: 0, y: giraffeDHeight)
//                    .padding(.bottom, 220.0)
    //                .resizable()
    //                .scaledToFit()
                    .mask(
                        RoundedRectangle(cornerRadius: 120)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 700)
                            .padding(.bottom, 420)
                    )
            }
            
            
            
            
//            RoundedRectangle(cornerRadius: 120.0)
//                .foregroundColor(.white)
//                .frame(width: 240, height: 400)
//                .padding(.bottom, 130)

            
            
            
            
            
            ZStack {

                        
                VStack {
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 36, height: 39)
                      .background(
                        Image("leaf")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 36, height: 39)
                          .clipped()
                      )
 
                    Text("+\(dLeaves)")
                        .font(Font.custom("Lilita One", size: 32))
                        .kerning(0.64)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.25, green: 0.47, blue: 0))
                        .frame(width: 100, height: 22, alignment: .center)  //宽度能容纳四位数
                        .offset(x: 0, y: -16)
                        .padding(.top, 8)
                        .padding(.trailing, 4)
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
                    withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                        scoreScale = 1.2
                    }
                    withAnimation(.easeOut(duration: 0.3).delay(1.0)) {
                        scoreScale = 0.8
                    }
                    withAnimation(.easeOut(duration: 0.2).delay(1.3)) {
                        scoreScale = 1.0
                    }
                    withAnimation(.linear(duration: 0.6).delay(1.5)) {
                        giraffeDHeight = -110.0
                    
                    }
                }
                
            }
            
            
            
            
            
            
            VStack(spacing: 40){
                Spacer()
                VStack(alignment: .center, spacing: 23) {
                    Text("哦哦～脖子长度+\(Int(scene.score / 5))cm")
                        .font(Font.custom("DFPYuanW9-GB", size: 25.05524))
                        .kerning(0.5011)
                        .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                    Text("现在我有\(neckLength)cm长的脖子\n可以看到日出风景啦")
                      .font(Font.custom("DFPYuanW7-GB", size: 16))
                      .kerning(0.64)
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                      .frame(width: 192, alignment: .center)
                      .lineSpacing(10)   //调整行间距
                } //text VStack
//                .padding(.top, 180)
                .onAppear() {
                    dLeaves = scene.score
                    totalLeaves = String(Int(totalLeaves)! + dLeaves)
                    dNeckLength = Int(scene.score / 5)
                    neckLength = String(Int(neckLength)! + dNeckLength)
                }
                
                
                
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
            .offset(x: 0, y: 10)
                        
            
            
            
           
        }

    }
}

struct CountScoreView_Previews: PreviewProvider {
    static var previews: some View {
        CountScoreView(neckLength: .constant("100"), totalLeaves: .constant("1443"), scene: GiraffeScene(), isInHomePage: .constant(false))
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


