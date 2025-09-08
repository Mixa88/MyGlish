//
//  LessonRowView.swift
//  MyGlish
//
//  Created by Михайло Тихонов on 08.09.2025.
//

import SwiftUI

struct LessonRowView: View {
    let lesson: Lesson
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(lesson.topic)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(lesson.date.formatted(date: .long, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            
            if !lesson.vocabulary.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "text.bubble.fill")
                    Text("\(lesson.vocabulary.count)")
                }
                .font(.footnote.bold())
                .foregroundStyle(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .clipShape(Capsule())
            }
        }
        .padding(.vertical, 8)
    }
}


