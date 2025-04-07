//
//  TabbarCV.swift
//  MazaadyTask
//
//  Created by mohamed dorgham on 07/04/2025.
//

import SwiftUI

struct TabbarCV: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeCV()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    }
                }
                .tag(0)
            
            FormCV()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 1 ? "map.fill" : "map")
                    }
                }
                .tag(1)
            
            Text("الرسائل")
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 2 ? "message.fill" : "message")
                    }
                }
                .tag(2)
            
            Text("الملف الشخصي")
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    }
                }
                .tag(3)
        }
        .accentColor(.pink)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().standardAppearance = appearance
        }
    }
}


struct TabbarCV_Previews: PreviewProvider {
    static var previews: some View {
        TabbarCV()
    }
}
