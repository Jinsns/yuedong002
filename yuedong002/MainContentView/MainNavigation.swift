//
//  MainNavigation.swift
//  yuedong002
//
//  Created by Jzh on 2023/6/26.
//

import SwiftUI

struct MainNavigation: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ContentView3()) {
                    Text("纯享模式，身随乐动")
                }
                
                NavigationLink(destination: CreateMode()) {
                    Text("动感创作，乐随身动")
                }
            }
        }
    }
}

struct MainNavigation_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigation()
    }
}
