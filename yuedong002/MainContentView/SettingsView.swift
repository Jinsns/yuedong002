//
//  SettingsView.swift
//  yuedong002
//
//  Created by Jzh on 2023/8/29.
//

import SwiftUI

//struct SettingsView: View {
//    var body: some View {
////        ExpandedSettingsView()
//    }
//}

struct ExpandedSettingsView: View {
    @ObservedObject var dataModel: DataModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                //设置提醒
                Button {
                    print("pressed alarm setting button")
                    withAnimation {
                        dataModel.isShowSettingsView = false
                        dataModel.isShowAlarmSettingView = true
                    }
                    
                } label: {
                    HStack(alignment: .center) {
                        HStack(alignment: .center) {
                          // Space Between
                            // Space Between
                              Image("Alarm")
                                  .frame(width: 30, height: 30)
                              Spacer()
                            // Alternative Views and Spacers
                              Text("提醒设置")
                                .font(Font.custom("DFPYuanW7-GB", size: 16))
                                .foregroundColor(Color(red: 0.18, green: 0.25, blue: 0.1))
                        }
                        .padding(0)
                        .frame(width: 102, alignment: .center)
                        
                      
                    }
                    .padding(.leading, 12)
                    .padding(.trailing, 18)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                //购买会员
                Button {
                    print("pressed buy vip button")
                } label: {
                    HStack(alignment: .center) {
                        HStack(alignment: .center) {
                          Image("Bag2")
                              .frame(width: 30, height: 30)
                          Spacer()
                          // Alternative Views and Spacers
                          Text("购买会员")
                            .font(Font.custom("DFPYuanW7-GB", size: 16))
                            .foregroundColor(Color(red: 0.18, green: 0.25, blue: 0.1))
                        }
                        .padding(0)
                        .frame(width: 102, alignment: .center)
                      
                    }
                    .padding(.leading, 12)
                    .padding(.trailing, 18)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                //联系我们
                Button {
                    print("pressed contact us button")
                } label: {
                    HStack(alignment: .center) {
                        HStack(alignment: .center) {
                            // Space Between
                              Image("Letter")
                                  .frame(width: 30, height: 30)
                              Spacer()
                            // Alternative Views and Spacers
                              Text("联系我们")
                                .font(Font.custom("DFPYuanW7-GB", size: 16))
                                .foregroundColor(Color(red: 0.18, green: 0.25, blue: 0.1))
                        }
                        .padding(0)
                        .frame(width: 102, alignment: .center)
                        
                      
                    }
                    .padding(.leading, 12)
                    .padding(.trailing, 18)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                
                
                
                
                
            }
            .padding(0)
            .background(.white.opacity(0.7))
            .cornerRadius(8)
            .frame(maxWidth: 135, alignment: .center)
        }
        
    }
}

struct AlarmSettingView: View {
    @ObservedObject var dataModel: DataModel
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            VStack(alignment: .center, spacing: 8) {
                Text("提醒设置")
                  .font(Font.custom("DFPYuanW9-GB", size: 17))
                  .multilineTextAlignment(.center)
                  .foregroundColor(.black.opacity(0.65))
                  .frame(maxWidth: .infinity, alignment: .center)
                
                HStack(alignment: .center, spacing: 0) {
                    Text("发消息提醒我")
                      .font(Font.custom("DFPYuanW7-GB", size: 12))
                      .foregroundColor(.black.opacity(0.65))
                      .lineLimit(1)
                    
                    Text("（PS：10:00 - 22:00）")
                      .font(Font.custom("DFPYuanW7-GB", size: 10))
                      .foregroundColor(.black.opacity(0.45))
                      .lineLimit(1)
                    
                    Spacer()
                    //switch
                    Toggle("", isOn: $dataModel.isOpenAlarm)
                      .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.41, green: 0.63, blue: 0.16)))
                      .frame(width: 42, height: 24)
                      .padding(.trailing, 8)
                }
                .padding(.top, 4)
                .frame(width: 250.5, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.top, 0)
            .padding(.bottom, 8)
            .frame(width: 270, alignment: .top)
            
            Button {
                print("pressed setting alarm completion")
                withAnimation {
                    dataModel.isShowAlarmSettingView = false
                }
                
            } label: {
                HStack(alignment: .top, spacing: 4) {
                    HStack(alignment: .center, spacing: 0) {
                        Text("完成")
                          .font(Font.custom("DFPYuanW9-GB", size: 17))
                          .multilineTextAlignment(.center)
                          .foregroundColor(.white)
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 11)
                    .frame(maxWidth: 270, alignment: .center)
                    .background(Color(red: 0.41, green: 0.63, blue: 0.16))
                    .cornerRadius(7)
                }
                .padding(7)
                .frame(maxWidth: 280, alignment: .top)
            }

            
        }
        .padding(.horizontal, 0)
        .padding(.top, 19)
        .padding(.bottom, 0)
        .background(.white)
        .cornerRadius(14)
        .frame(width: .infinity)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
//        SettingsView()
        ExpandedSettingsView(dataModel: DataModel())
//        AlarmSettingView(dataModel: DataModel())
//            .environmentObject(DataModel())
    }
}
