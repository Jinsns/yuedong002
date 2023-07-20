//
//  Relaxing.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/20.
//

import SwiftUI
import AVFoundation
import CoreMotion

struct Relaxing: View {
    @State var isAirPodsDisconnected = false
    
    
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
            checkAirPodsConnection()
            if isAirPodsDisconnected {
                
            }
        }
        
    }
    
    
    func checkAirPodsConnection() {
            
        if CMHeadphoneMotionManager().isDeviceMotionAvailable {
            isAirPodsDisconnected = false
        } else {
            isAirPodsDisconnected = true
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
         } else {
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
     }
    
    
}

struct Relaxing_Previews: PreviewProvider {
    static var previews: some View {
        Relaxing()
    }
}
