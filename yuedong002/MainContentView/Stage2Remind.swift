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

struct Filter15s: View {
    var body: some View {
        Image("filter15s")
            .resizable()
            .edgesIgnoringSafeArea(.all)
    }
}

struct Wow: View {
    var body: some View {
        VStack {
            Image("Wow")
                .padding(.top, 220)
            
            Spacer()
        }
    }
}

struct Taikula: View {
    var body: some View {
        VStack {
            
            Image("taikula")
                .padding(.top, 220)
            
            Spacer()
        }
    }
}

struct Likeyou: View {
    var body: some View {
        VStack {
            
            Image("likeyou")
                .padding(.top, 220)
            
            Spacer()
        }
    }
}

struct handSupportRemindView: View {
    var body: some View {
        VStack {
            Image("handSupport")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .offset(x: 0, y: -100)
        }
        
    }
}

struct Stage2Remind_Previews: PreviewProvider {
    static var previews: some View {
//        Stage2Remind()
//        Wow()
//        Taikula()
//        Likeyou()
//        Filter15s()
        handSupportRemindView()
        
    }
}
