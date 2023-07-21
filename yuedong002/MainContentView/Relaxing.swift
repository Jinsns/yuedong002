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
    @State var isAirPodsDisconnected = false
    @State var isCheckingAirpods = false
    @ObservedObject var motionManager = MotionManager()
    @State var isHeadPositionChecked = false
    
    @State private var currentTime: TimeInterval = 0
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
//    @State var pitch = 3.14 / 4
//    @State var roll = 3.14 / 4
    
    
    var body: some View {
        ZStack{
            Image("Ellipse")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.vertical)
            
            Image("RabbitEllipse")
                .resizable()
                .scaledToFit()
                .frame(width: 289, height: 498)
                .padding()
            
        }
        .overlay(
                    disconnectedOverlay
                        .padding()
                        .padding(.bottom, 450)
                    
                        
                )
        .onAppear() {
            //检测airpods
//            checkAirPodsConnection()
            startAirpodsViewTimer()
            
            isAirPodsDisconnected = false  //假装已经连接上耳机了
            isCheckingAirpods = true
            
            //检测头部初始姿势
            startHeadPositionCheckTimer(isHeadPositionChecked: $isHeadPositionChecked)
            
        }
        .onChange(of: isCheckingAirpods) { newvalue in
            startHeadPositionCheckTimer(isHeadPositionChecked: $isHeadPositionChecked)
        }
        
    }
    
    
    func checkAirPodsConnection() {
            
        if CMHeadphoneMotionManager().isDeviceMotionAvailable {
            isAirPodsDisconnected = false
        } else {
            isAirPodsDisconnected = true
            isCheckingAirpods = true
            startAirpodsViewTimer()
        }
    }
    
    
    var disconnectedOverlay: some View {
         if isAirPodsDisconnected {
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
        } else {
            return AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .overlay(
                       HStack{
                           Image(systemName: "checkmark.circle")
                           
                           Text("初识姿势就绪")
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
    
    
    
    func startAirpodsViewTimer() {
        isCheckingAirpods = true
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                isCheckingAirpods = false
            }
    }
    
    
    init() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
                        }
                        isTiming = false
                    }
                }
            } else {
                isTiming = false
            }
        }
    }
    

}

struct Relaxing_Previews: PreviewProvider {
    static var previews: some View {
        Relaxing()
    }
}
