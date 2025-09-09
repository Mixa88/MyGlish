//
//  AddWordView.swift
//  MyGlish
//
//  Created by Михайло Тихонов on 06.09.2025.
//


import SwiftUI

struct AddWordView: View {
    @State private var word = ""
    @State private var translation = ""
    @Environment(\.dismiss) var dismiss
    
    
    let lessonDate: Date
    
    var onAdd: (VocabularyWord) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("New Word", text: $word)
                TextField("Translation", text: $translation)
            }
            .navigationTitle("Add Word")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        
                        let newWord = VocabularyWord(word: word, translation: translation, dateAdded: lessonDate)
                        onAdd(newWord)
                        dismiss()
                    }
                    .disabled(word.isEmpty || translation.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddWordView(lessonDate: .now) { word in
        print("Added word: \(word.word)")
    }
}
