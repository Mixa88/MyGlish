//
//  ContentView.swift
//  MyGlish
//
//  Created by Михайло Тихонов on 04.09.2025.
//

import SwiftUI

struct MainAppView: View {
    var body: some View {
        TabView {
            LessonsListView()
                .tabItem {
                    Label("Lessons", systemImage: "book")
                }
            
            Text("Here will be a list of words")
                .tabItem {
                    Label("Words", systemImage: "square.and.arrow.up")
                }
        }
    }
}

#Preview {
    MainAppView()
}
