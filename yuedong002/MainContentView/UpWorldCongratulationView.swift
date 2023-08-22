//
//  UpWorldCongratulationView.swift
//  yuedong002
//
//  Created by Jzh on 2023/8/21.
//

import SwiftUI

struct UpWorldCongratulationView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .edgesIgnoringSafeArea(.all)
              .foregroundColor(.clear)
//              .frame(width: 402, height: 852)
              .background(.black.opacity(0.6))
            Image("upWorldCongratulation")
                .frame(width: 580, height: 603)
            
            
        }
    }
}

struct UpWorldCongratulationView_Previews: PreviewProvider {
    static var previews: some View {
        UpWorldCongratulationView()
    }
}
