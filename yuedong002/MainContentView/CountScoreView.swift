//
//  CountScoreView.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/27.
//

import SwiftUI

struct CountScoreView: View {
    @Binding var finalScore: Int
    
    
    
    
    
    
    var body: some View {
        ZStack{
            Image("songEnd")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
//                .padding(.horizontal, 14)
//                .padding(.trailing, 10)
            
            
            
            ZStack {
//                        Circle()
//                            .foregroundColor(.white)
//                            .opacity(0.7)
//                            .frame(width: 100, height: 100)
                        
                VStack {
                    Image("leaf")
                        .foregroundColor(.white)
                        .scaledToFit()
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(width: 40)
                        .offset(x: 0, y: 6)
                        .padding(.top, 20)
 
                    Text(" + \(finalScore)")
                        .foregroundColor(.green)
                        .font(.headline)
                        .offset(x: 0, y: -16)
                        .padding(.bottom, 20)
                }
                .background(
                    Circle()
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .frame(width: 90, height: 90)
                )
            }
            .offset(x: 120, y:-100)
            
            
            VStack{
                
                VStack{
                    Text("哦哦～脖子长度+5cm")
                        .font(.title2)
                        .foregroundColor(Color(hex: "68A128"))
                    Text("现在我有128cm长的脖子").foregroundColor(Color(hex: "68A128"))
                        .padding(.top, 16)
                    Text("可以看到日出风景了")
                        .padding(.top, 2)
                        .foregroundColor(Color(hex: "68A128"))
                }  //text VStack
                .offset(x: 0, y: 280)
                
                
                
                
                
                Button {
                    print("want to go back to main page")
                } label: {
                    Text("返回主页")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: "68A128"))
                        .cornerRadius(7) // 设置圆角半径
                }
                .offset(x: 0, y: 330)
                .padding(.bottom, 100)

            }
                        
            
            
            
           
        }
    }
}

struct CountScoreView_Previews: PreviewProvider {
    static var previews: some View {
        CountScoreView(finalScore: .constant(0))
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


