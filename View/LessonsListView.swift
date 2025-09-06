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
    
    var body: some View {
        NavigationStack {
            Group {
                if lessons.isEmpty {
                    ContentUnavailableView(
                        "No Lessons Yet",
                        systemImage: "book.closed",
                        description: Text("Click + to add your first lesson.")
                    )
                } else {
                    List {
                        
                        ForEach(lessons) { lesson in
                            NavigationLink(value: lesson) {
                                VStack(alignment: .leading) {
                                    Text(lesson.topic)
                                        .font(.headline)
                                    Text(lesson.date.formatted(date: .long, time: .omitted))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: deleteLesson)
                    }
                    .navigationDestination(for: Lesson.self) { lesson in
                        DetailLessonView(lesson: lesson)
                    }
                }
            }
            .navigationTitle("Lessons 📚")
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
            let lesson = lessons[offset]
            modelContext.delete(lesson)
        }
    }
}


#Preview {
    LessonsListView()
        .modelContainer(for: [Lesson.self, VocabularyWord.self], inMemory: true)
}
