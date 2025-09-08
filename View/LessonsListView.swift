//
//  LessonsListView.swift
//  MyGlish
//
//  Created by Михайло Тихонов on 04.09.2025.
//

import SwiftUI
import SwiftData

struct LessonsListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Lesson.date, order: .reverse) var lessons: [Lesson]
    
    @State private var showingAddScreen = false
    @State private var searchText = ""

    var filteredLessons: [Lesson] {
        if searchText.isEmpty {
            return lessons
        } else {
            return lessons.filter { $0.topic.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if filteredLessons.isEmpty {
                    if searchText.isEmpty {
                        ContentUnavailableView(
                            "No Lessons Yet",
                            systemImage: "book.closed",
                            description: Text("Click + to add your first lesson.")
                        )
                    } else {
                        ContentUnavailableView.search(text: searchText)
                    }
                } else {
                    List {
                        ForEach(filteredLessons) { lesson in
                            NavigationLink(value: lesson) {
    
                                LessonRowView(lesson: lesson)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.background) // Используем фоновый цвет системы
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    .padding(.vertical, 4)
                            )
                            .listRowSeparator(.hidden) // Скрываем стандартный разделитель
                        }
                        .onDelete(perform: deleteLesson)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Lessons 📚")
            .searchable(text: $searchText, prompt: "Search Lessons")
            .navigationDestination(for: Lesson.self) { lesson in
                DetailLessonView(lesson: lesson)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Lesson", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: $showingAddScreen) {
            AddLessonView()
        }
    }
    
    func deleteLesson(at offsets: IndexSet) {
        for offset in offsets {
            if let index = lessons.firstIndex(of: filteredLessons[offset]) {
                let lessonToDelete = lessons[index]
                modelContext.delete(lessonToDelete)
            }
        }
    }
}


// MARK: - Preview
#Preview {
    let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Lesson.self, VocabularyWord.self, configurations: config)
        
        let lesson = Lesson(date: .now, topic: "Preview Lesson")
        let word1 = VocabularyWord(word: "Preview", translation: "Превью")
        lesson.vocabulary = [word1]
        
        container.mainContext.insert(lesson)
        container.mainContext.insert(word1)
        word1.lesson = lesson

        return container
    }()
    
    LessonsListView()
        .modelContainer(container)
}
