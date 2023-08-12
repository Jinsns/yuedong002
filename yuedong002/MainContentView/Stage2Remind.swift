//
//  Stage2Remind.swift
//  yuedong002
//
//  Created by Jzh on 2023/8/12.
//

import SwiftUI

struct Stage2Remind: View {
    var body: some View {
        ZStack {
            
            
            
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(.clear)
    //            .frame(width: 393, height: 852)
                .background(.black.opacity(0.6))
            
            Image("Stage2Reminder")
                .frame(width: 251, height: 251)

            
            
        }
        
        
        
    }
}

struct Stage2Remind_Previews: PreviewProvider {
    static var previews: some View {
        Stage2Remind()
    }
}
