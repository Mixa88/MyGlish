//
//  DetailLessonView.swift
//  MyGlish
//
//  Created by Михайло Тихонов on 06.09.2025.
//

import SwiftUI
import SwiftData

struct DetailLessonView: View {
    
    let lesson: Lesson
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - General Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.topic)
                        .font(.largeTitle.weight(.bold))
                    Text(lesson.date.formatted(date: .long, time: .omitted))
                        .foregroundStyle(.secondary)
                }
                
                // MARK: - Stats Section
                HStack {
                    Image(systemName: "timer")
                    Text("\(lesson.durationInMinutes) min")
                    Spacer()
                }
                .font(.headline)
                .padding()
                .background(.thinMaterial, in: .rect(cornerRadius: 12))
                
                
                // MARK: - Details Section
                if let grammar = lesson.grammarTopics, !grammar.isEmpty {
                    detailSection(title: "Grammar", content: grammar, icon: "text.book.closed")
                }
                
                if let homework = lesson.homework, !homework.isEmpty {
                    detailSection(title: "Homework", content: homework, icon: "pencil.and.ruler")
                }
                
                if let notes = lesson.notes, !notes.isEmpty {
                    detailSection(title: "Notes", content: notes, icon: "note.text")
                }
                
                // MARK: - Vocabulary Section
                if !lesson.vocabulary.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Vocabulary", systemImage: "text.bubble")
                            .font(.title2.bold())
                        
                        
                        ForEach(lesson.vocabulary.sorted { $0.word < $1.word }) { word in
                            HStack {
                                Text(word.word).bold()
                                Text("–")
                                Text(word.translation).foregroundStyle(.secondary)
                            }
                            .font(.callout)
                            Divider()
                        }
                    }
                }
                
            }
            .padding()
        }
        .navigationTitle(lesson.topic)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    @ViewBuilder
    private func detailSection(title: String, content: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon)
                .font(.title2.bold())
            Text(content)
                .padding(.leading, 35)
        }
    }
}



#Preview {
    
    do {
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Lesson.self, configurations: config)

        
        let exampleLesson = Lesson(date: .now, topic: "Present Perfect Tense", durationInMinutes: 60, grammarTopics: "Usage with 'for' and 'since'", homework: "Workbook p. 45, ex. 3-5", notes: "Focus on the difference between Present Perfect and Past Simple. Good progress today.")
        
        
        let word1 = VocabularyWord(word: "since", translation: "с тех пор как")
        let word2 = VocabularyWord(word: "already", translation: "уже")
        exampleLesson.vocabulary = [word1, word2]
        word1.lesson = exampleLesson
        word2.lesson = exampleLesson
        
        
        return NavigationStack {
            DetailLessonView(lesson: exampleLesson)
                .modelContainer(container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
