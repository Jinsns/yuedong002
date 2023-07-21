//
//  Relaxing.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/20.
//

import SwiftUI
import AVFoundation
import CoreMotion
import Combine

struct Relaxing: View {
    @State var isAirPodsConnected = false
    @State var isCheckingAirpods = false
    @ObservedObject var motionManager = MotionManager()
    @State var isHeadPositionChecked = false
    @State var isShowingHeadPositionReady = false
    @State var isShowingCloseEyeReminder = false
    

    
    
    var body: some View {
        ZStack{
            Image("Ellipse")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.vertical)
                .brightness(isShowingCloseEyeReminder ? -0.6 : 0 )
                .animation(.easeInOut(duration: 0.5))
            
            
            
            Image("RabbitEllipse")
                .resizable()
                .scaledToFit()
                .frame(width: 289, height: 498)
                .padding()
            
        }
        .overlay(
                    textReminderOverlay
                        .padding()
                        .padding(.bottom, 450)
                    
                        
                )
        .onAppear() {
            //检测airpods
//            checkAirPodsConnection()
            startAirpodsViewTimer()
            
            isAirPodsConnected = true  //假装已经连接上耳机了
            isCheckingAirpods = true
            
            //检测头部初始姿势
            startHeadPositionCheckTimer(isHeadPositionChecked: $isHeadPositionChecked)
            
        }
        .onChange(of: isCheckingAirpods) { newvalue in
            startHeadPositionCheckTimer(isHeadPositionChecked: $isHeadPositionChecked)
        }
        
    }
    
    
    
    var textReminderOverlay: some View {
         if !isAirPodsConnected {
             return AnyView(
                 RoundedRectangle(cornerRadius: 10)
                     .foregroundColor(.white)
                     .overlay(
                         Text("请连接您的AirPods")
                             .foregroundColor(.green)
                             .padding()
                     )
                     .frame(width: 300, height: 60)
                     .opacity(0.8)
                 
             )
         } else if isCheckingAirpods{
             return AnyView(
                 RoundedRectangle(cornerRadius: 10)
                     .foregroundColor(.white)
                     .overlay(
                        HStack{
                            Image(systemName: "checkmark.circle")
                            Text("Airpods 已连接")
                        }
                         .foregroundColor(.green)
                         .padding()
                     )
                     .frame(width: 300, height: 60)
                     .opacity(0.8)
                    
                 )
         }
        
        else if !isHeadPositionChecked{
            return AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .overlay(
                       VStack{
                           Text("移动头部至原点")
                               .font(.title)
                               
                           VStack {
                               Text("前后方向：\(motionManager.pitch) ")
                               Text("左右方向：\(motionManager.roll) ")
                           }
                           .font(.subheadline)
//                           Text("x : \(motionManager.yaw)")
                       }
                        .foregroundColor(.green)
                        
                    )
                    .frame(width: 300, height: 100)
                    .opacity(isHeadPositionChecked ? 0 : 0.8)
                   
                )
        } else if isShowingHeadPositionReady {
            return AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .overlay(
                       HStack{
                           Image(systemName: "checkmark.circle")
                           
                           Text("初始姿势就绪")
                       }
                        .foregroundColor(.green)
                        .padding()
                    )
                    .frame(width: 300, height: 60)
                    .opacity(0.8)
                   
                )
        } else {
            return AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .overlay(
                       HStack{
                           Text("闭上眼，跟随音乐的脚步")
                       }
                        .foregroundColor(.green)
                        .padding()
                    )
                    .frame(width: 300, height: 60)
                    .opacity(0.8)
                   
                )
        }
        return AnyView(Text("空"))
        
        
     }
    
    
    func checkAirPodsConnection() {
            
        if CMHeadphoneMotionManager().isDeviceMotionAvailable {
            isAirPodsConnected = true
        } else {
            isAirPodsConnected = false
            isCheckingAirpods = true
            startAirpodsViewTimer()
        }
    }
    
    
    // 在3秒后将 isCheckingAirpods 设置为 false
    func startAirpodsViewTimer() {
        isCheckingAirpods = true
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            isCheckingAirpods = false
        }
    }
    
    
    
    
    func startHeadPositionCheckTimer(isHeadPositionChecked: Binding<Bool>) {
        var counter = 0
        var isTiming = false
        
        //repeat every 0.1s, so when counter equals 20, 2s reaches
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if abs(motionManager.pitch) < 0.4 && abs(motionManager.roll) < 0.4 {
                if !isTiming {
                    isTiming = true
                    counter = 0
                } else {
                    counter += 1
                    if counter >= 20 { // 20 * 0.1秒 = 2秒
                        DispatchQueue.main.async {
                            isHeadPositionChecked.wrappedValue = true
                            showHeadPositionReady()
                        
                        }
//                        isTiming = false
                    }
                    if counter >= 40 {
                        DispatchQueue.main.async {
                            startCloseEyeReminderTimer()
                        }
                        isTiming = false
                    }
                }
            } else {
                isTiming = false
            }
        }
    }
    
    
    func showHeadPositionReady() {
        isShowingHeadPositionReady = true
    
    }

    
    func startCloseEyeReminderTimer() {
        isShowingHeadPositionReady = false
        isShowingCloseEyeReminder = true
        
    }
    

}

struct Relaxing_Previews: PreviewProvider {
    static var previews: some View {
        Relaxing()
    }
}
