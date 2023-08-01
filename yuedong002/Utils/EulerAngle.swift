//
//  EulerAngle.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/31.
//

import SwiftUI


struct EulerAngle: View {
    @ObservedObject var motionManager = MotionManager()
    var body: some View {
        VStack {
            Text(String(format: "pitch方向  %.1f", motionManager.pitch) )
            Text(String(format: "yaw方向    %.1f", motionManager.yaw) )
            Text(String(format: "roll方向   %.1f", motionManager.roll) )
//            Text("yaw 旋转方向：\(motionManager.yaw) ")
//            Text("roll 左右方向：\(motionManager.roll) ")
        }
    }
}

struct EulerAngle_Previews: PreviewProvider {
    static var previews: some View {
        EulerAngle()
    }
}
