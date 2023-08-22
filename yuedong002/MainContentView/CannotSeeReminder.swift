//
//  CannotSeeReminder.swift
//  yuedong002
//
//  Created by Jzh on 2023/8/22.
//

import SwiftUI

struct CannotSeeHigherReminder: View {
    var body: some View {
        VStack {
            
            Image("cannotSeeHigher")
                .padding(.top, 160)
            Spacer()
            
            
        }
        
    }
}

struct CannotSeeLowerReminder: View {
    var body: some View {
        VStack {
            Spacer()
            Image("cannotSeeLower")
                .padding(.bottom, 400)
        }
    }
}

struct CannotSeeReminder_Previews: PreviewProvider {
    static var previews: some View {
        CannotSeeHigherReminder()
//        CannotSeeLowerReminder()
    }
}
