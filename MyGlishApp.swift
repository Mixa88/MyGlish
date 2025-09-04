//
//  MyGlishApp.swift
//  MyGlish
//
//  Created by Михайло Тихонов on 04.09.2025.
//

import SwiftUI
import SwiftData

@main
struct MyGlishApp: App {
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
        .modelContainer(for: Lesson.self)
    }
}
