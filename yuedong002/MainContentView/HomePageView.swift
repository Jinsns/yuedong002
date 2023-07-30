//
//  HomePageView.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/29.
//


import SwiftUI


/* fonts name：
 DFPYuanW3
 DFPYuanW5
DFPYuanW7
DFPYuanW9
 */


struct HomePageView: View {
    @State var isShowAirpodsReminder = false
    @State var isShowNodToEatReminder = false
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                Image("AirpodsReminder")
            }
            .padding(0)
            .padding(.bottom, 230)
            .scaleEffect(isShowAirpodsReminder ? 1 : 0)
            .animation(.spring())
            .onAppear {
                withAnimation {
                    isShowAirpodsReminder = true
                }
            }

            
//            VStack(alignment: .center, spacing: 0) {
//                Image("NodToEatReminder")
//            }
//            .padding(0)
//            .padding(.bottom, 230)
//            .scaleEffect(isShowNodToEatReminder ? 1.0 : 0.0) // 控制视图的缩放效果
//            .animation(.spring())  // 添加动画效果，这里使用了弹性动画
//            .onAppear { // 在视图出现时触发动画
//                withAnimation {
//                    isShowNodToEatReminder = true
//                }
//            }
        
            
            
            VStack {  //icons at the corners
                HStack(alignment: .top, spacing: 205) {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack(alignment: .center, spacing: 8) {  //NeckIcon  123cm
                            Image("NeckIcon")
                            .frame(width: 32, height: 32)
                            Text("123")
                              .font(Font.custom("DFPYuanW9-GB", size: 20))
                              .foregroundColor(Color(red: 0.32, green: 0.51, blue: 0.1))
                            Text("cm")
                              .font(Font.custom("DFPYuanW9-GB", size: 20))
                              .foregroundColor(Color(red: 0.32, green: 0.51, blue: 0.1))
                              .frame(width: 26, height: 14, alignment: .leading)
                        }
                        .padding(0)
                        
                        HStack(alignment: .center, spacing: 8) { //EarthIcon 地面
                            Image("EarthIcon")
                            .frame(width: 32, height: 32)
                            Text("地面")
                              .font(.custom("DFPYuanW9-GB", size: 16))
                              .kerning(1.28)
                              .foregroundColor(Color(red: 0.32, green: 0.51, blue: 0.1))
                        }
                        .padding(0)
                    }
                    .padding(0)
                    
                    
                    HStack(alignment: .center, spacing: 9.85389) {  //button hstack
                        Button {
                            print("pressed settings button")
                        } label: {
                            Image("SettingsButton")
                        }
                    }
                    .frame(width: 32, height: 32, alignment: .leading)
                }  //hstack of NeckIcon, EarthIcon, SettingsButton
                .padding(.top, 70)
                
                Spacer()
                
                HStack(alignment: .top, spacing: 205) {
                    HStack(alignment: .top, spacing: 10) {
                        Button {
                            print("pressed PhotoIcon")
                        } label: {
                            Image("PhotoIcon")
                        }

                    } //HStack of PhotoIcon
                    .padding(10)
                    .frame(width: 52, height: 52, alignment: .topLeading)
                    .background(.white.opacity(0.6))
//                    .cornerRadius(50)
                    
                    
                    HStack(alignment: .top, spacing: 10) {
                        Button {
                            print("pressed EyeGlassesIcon")
                        } label: {
                            Image("EyeGlassesIcon")
                        }
                    }  //HStack of EyeGlassesIcon
                    .padding(10)
                    .frame(width: 52, height: 52, alignment: .topLeading)
                    .background(.white.opacity(0.6))
//                    .cornerRadius(50)
                    
                } //HStack of PhotoIcon, EyeGlassesIcon
                .padding(0)
                .frame(width: 309, height: 52, alignment: .top)
                
                
                
               
                
            }
            .foregroundColor(.clear)
            .frame(width: 393, height: 852)
        }
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
