//
//  AddLessonView.swift
//  MyGlish
//
//  Created by Михайло Тихонов on 04.09.2025.
//

import SwiftUI
import SwiftData

struct AddLessonView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    // MARK: - State Properties
    @State private var topic: String = ""
    @State private var date: Date = .now
    @State private var durationInMinutes: Int = 60
    @State private var grammarTopics: String = ""
    @State private var homework: String = ""
    @State private var notes: String = ""
    
    @State private var newWords: [VocabularyWord] = []
    @State private var showingAddWord = false
    
    
    var lesson: Lesson?
    
    var isFormValid: Bool {
        !topic.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Main Info") {
                    TextField("Lesson topic", text: $topic)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section("Details") {
                    Stepper("Duration: \(durationInMinutes) min", value: $durationInMinutes, in: 15...180, step: 15)
                    TextField("Grammar Topics (optional)", text: $grammarTopics)
                    TextField("Homework (optional)", text: $homework)
                }
                
                Section("New Vocabulary") {
                    ForEach(newWords) { word in
                        HStack {
                            Text(word.word).bold()
                            Text("–")
                            Text(word.translation).foregroundStyle(.green)
                            Spacer()
                        }
                    }
                    .onDelete(perform: deleteWord)
                    
                    Button(action: { showingAddWord.toggle() }) {
                        Label("Add Word", systemImage: "plus")
                    }
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 150)
                }
            }
            .navigationTitle(lesson == nil ? "New Lesson" : "Edit Lesson")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveLesson)
                        .disabled(!isFormValid)
                }
            }
            .sheet(isPresented: $showingAddWord) {
                
                AddWordView(lessonDate: self.date) { newWord in
                    newWords.append(newWord)
                }
            }
            .onAppear(perform: setupForm)
        }
    }
    
    private func setupForm() {
        if let lesson {
            topic = lesson.topic
            date = lesson.date
            durationInMinutes = lesson.durationInMinutes
            grammarTopics = lesson.grammarTopics ?? ""
            homework = lesson.homework ?? ""
            notes = lesson.notes ?? ""
            newWords = lesson.vocabulary
        }
    }
    
    private func saveLesson() {
        if let lesson {
            
            lesson.topic = topic
            lesson.date = date
            lesson.durationInMinutes = durationInMinutes
            lesson.grammarTopics = grammarTopics.isEmpty ? nil : grammarTopics
            lesson.homework = homework.isEmpty ? nil : homework
            lesson.notes = notes.isEmpty ? nil : notes
            lesson.vocabulary = newWords
            for word in newWords {
                word.lesson = lesson
            }
        } else {
            
            let newLesson = Lesson(
                date: date,
                topic: topic,
                durationInMinutes: durationInMinutes,
                grammarTopics: grammarTopics.isEmpty ? nil : grammarTopics,
                homework: homework.isEmpty ? nil : homework,
                notes: notes.isEmpty ? nil : notes
            )
            
            newLesson.vocabulary = newWords
            for word in newWords {
                word.lesson = newLesson
            }
            modelContext.insert(newLesson)
        }
        
        
        try? modelContext.save()
        
        dismiss()
    }
    
    private func deleteWord(at offsets: IndexSet) {
        newWords.remove(atOffsets: offsets)
    }
}

#Preview("Create Mode") {
    AddLessonView()
}

#Preview("Edit Mode") {
    let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Lesson.self, configurations: config)
        let lesson = Lesson(date: .now, topic: "Existing Lesson")
        return container
    }()
    
    
    let fetchDescriptor = FetchDescriptor<Lesson>()
    let lesson = try! container.mainContext.fetch(fetchDescriptor).first!
    
    return AddLessonView(lesson: lesson)
        .modelContainer(container)
}
