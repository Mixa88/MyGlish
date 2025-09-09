//
//  DetailLessonView.swift
//  MyGlish
//
//  Created by Михайло Тихонов on 06.09.2025.
//

import SwiftUI
import SwiftData

struct DetailLessonView: View {
    
    
    @State private var isShowingEditView = false
    
    @Bindable var lesson: Lesson
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                
                // MARK: - General Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.topic)
                        .font(.largeTitle.weight(.bold))
                    Text(lesson.date.formatted(date: .long, time: .omitted))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                
                // MARK: - Cards Section
                VStack(spacing: 15) {
                    cardView(
                        title: "Duration",
                        icon: "timer",
                        content: "\(lesson.durationInMinutes) min",
                        gradientColors: [.blue, .purple]
                    )
                    
                    if let grammar = lesson.grammarTopics, !grammar.isEmpty {
                        cardView(
                            title: "Grammar",
                            icon: "text.book.closed",
                            content: grammar,
                            gradientColors: [.green, .teal]
                        )
                    }
                    
                    if let homework = lesson.homework, !homework.isEmpty {
                        cardView(
                            title: "Homework",
                            icon: "pencil.and.ruler",
                            content: homework,
                            gradientColors: [.orange, .yellow]
                        )
                    }
                    
                    if let notes = lesson.notes, !notes.isEmpty {
                        cardView(
                            title: "Notes",
                            icon: "note.text",
                            content: notes,
                            gradientColors: [.gray, .secondary]
                        )
                    }
                    
                    if !lesson.vocabulary.isEmpty {
                        vocabularyCardView()
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationTitle(lesson.topic)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isShowingEditView.toggle()
                }
            }
        }
        .sheet(isPresented: $isShowingEditView) {
            
            AddLessonView(lesson: lesson)
        }
    }
    
    
    @ViewBuilder
    private func cardView(title: String, icon: String, content: String, gradientColors: [Color]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white.opacity(0.8))
            
            Text(content)
                .font(.body)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    @ViewBuilder
    private func vocabularyCardView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Vocabulary (\(lesson.vocabulary.count))", systemImage: "text.bubble")
                .font(.headline.weight(.bold))
                .foregroundStyle(.white.opacity(0.8))
            
            Divider().overlay(Color.white.opacity(0.5))
            
            ForEach(lesson.vocabulary.sorted { $0.word < $1.word }) { word in
                HStack {
                    Text(word.word).bold()
                    Text("–")
                    Text(word.translation)
                }
                .font(.body)
            }
            .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.red, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}



#Preview {
    
    let exampleLesson = Lesson(date: .now, topic: "Present Perfect Tense", durationInMinutes: 60, grammarTopics: "Usage with 'for' and 'since'", homework: "Workbook p. 45, ex. 3-5", notes: "Focus on the difference between Present Perfect and Past Simple.")
    
    
    let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Lesson.self, VocabularyWord.self, configurations: config)
        
        
        let word1 = VocabularyWord(word: "since", translation: "с тех пор как", dateAdded: .now)
        let word2 = VocabularyWord(word: "already", translation: "уже", dateAdded: .now)
        
        
        container.mainContext.insert(exampleLesson)
        container.mainContext.insert(word1)
        container.mainContext.insert(word2)
        
        exampleLesson.vocabulary = [word1, word2]
        word1.lesson = exampleLesson
        word2.lesson = exampleLesson
        
        return container
    }()

    
    NavigationStack {
        DetailLessonView(lesson: exampleLesson)
            .modelContainer(container)
    }
}
