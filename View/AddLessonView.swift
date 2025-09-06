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
    
    @State private var topic: String = ""
    @State private var date: Date = .now
    @State private var durationInMinutes: Int = 60
    @State private var grammarTopics: String = ""
    @State private var homework: String = ""
    @State private var notes: String = ""
    
    @State private var newWords: [VocabularyWord] = []
    @State private var showingAddWord = false
    
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
                            Text(" – ")
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
            .navigationTitle("New Lesson")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                        }
                 }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: saveLesson)
                        .disabled(!isFormValid)
                }
            }
            .sheet(isPresented: $showingAddWord) {
                    AddWordView { newWord in
                    newWords.append(newWord)
                }
            }
        }
    }
    
    private func saveLesson() {
            
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
                dismiss()
        }
    
    private func deleteWord(at offsets: IndexSet) {
        newWords.remove(atOffsets: offsets)
    }
}

#Preview {
    AddLessonView()
}
