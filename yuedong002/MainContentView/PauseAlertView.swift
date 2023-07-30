//
//  PauseAlertView.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/29.
//

import SwiftUI

struct PauseAlertView: View {
    @Environment(\.colorScheme) private var colorScheme
        
    @Binding var isShowPause: Bool
    
    @Binding var isShowCountScoreView: Bool
    @Binding var leafNum: Int
//    var dNeckLength: Int
        
        var body: some View {
            ZStack {
                
                
                
                VStack(alignment: .center, spacing: 2) {
                    
                    VStack(alignment: .center, spacing: 8) {
                        Text("游戏已暂停")
                          .font(Font.custom("DFPYuanW9-GB", size: 17))
                          .multilineTextAlignment(.center)
                          .foregroundColor(.black.opacity(0.65))
                          .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("当前已获得：\n叶子数+\(leafNum)\n脖子长度+\(Int(leafNum / 5))")
                          .font(Font.custom("DFPYuanW7-GB", size: 12))
                          .multilineTextAlignment(.center)
                          .foregroundColor(.black.opacity(0.65))
                          .frame(maxWidth: .infinity, alignment: .center)
                          .lineSpacing(5)   //调整行间距
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 0)
                    .padding(.bottom, 8)
                    .frame(width: 270, alignment: .top)
                    
                    
                    
                    
                    HStack(alignment: .top, spacing: 5) {
                        
                        HStack(alignment: .center, spacing: 0) {
                            Button(action: {
                                print("pressed end this game")
                                self.isShowPause = false
                                self.isShowCountScoreView = true
                                
                                
                            }) {
                                Text("结束")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal, 0)
                        .padding(.vertical, 11)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                        .cornerRadius(7)
                        
                        
                        
                        HStack(alignment: .center, spacing: 0) {
                            Button {
                                print("pressed continue")
                                self.isShowPause = false
                            } label: {
                                Text("继续")
                                    .foregroundColor(.white)
                            }
                            
                        }
                        .padding(.horizontal, 0)
                        .padding(.vertical, 11)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color(red: 0.41, green: 0.63, blue: 0.16))
                        .cornerRadius(7)
                        
                        
                    }
                    .padding(7)
                    .frame(maxWidth: .infinity, alignment: .top)

                    

                }
                .frame(width: 270, height: 152)
                .padding(.horizontal, 0)
                .padding(.top, 19)
                .padding(.bottom, 0)
                .background(.white)
                .cornerRadius(14)
                
                
                
            }
        }
}

struct PauseAlertView_Previews: PreviewProvider {
    static var previews: some View {
        PauseAlertView(isShowPause: .constant(true), isShowCountScoreView: .constant(false), leafNum: .constant(8))
    }
}
