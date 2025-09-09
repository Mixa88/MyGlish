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
            
            DictionaryView()
                .tabItem {
                    Label("Words", systemImage: "text.book.closed.fill")
                }
            
            FlashcardView()
                .tabItem {
                    Label("Trainer", systemImage: "rectangle.stack.fill")
                }
        }
    }
}

#Preview {
    MainAppView()
}
