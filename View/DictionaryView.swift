//
//  DictionaryView.swift
//  MyGlish
//
//  Created by Михайло Тихонов on 07.09.2025.
//

import SwiftUI
import SwiftData

struct DictionaryView: View {
    
    @Query(sort: \VocabularyWord.lesson?.date, order: .reverse) var words: [VocabularyWord]
    
    @State private var searchText = ""

    private var filteredWords: [VocabularyWord] {
        if searchText.isEmpty {
            return words
        } else {
            
            return words.filter {
                $0.word.localizedCaseInsensitiveContains(searchText) ||
                $0.translation.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private var groupedWords: [Date: [VocabularyWord]] {
        
        let validWords = filteredWords.filter { $0.lesson != nil }
        
        return Dictionary(grouping: validWords) { word in
            Calendar.current.startOfDay(for: word.lesson?.date ?? .distantPast)
        }
    }
    
    private var sortedDates: [Date] {
        groupedWords.keys.sorted(by: >)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedDates, id: \.self) { date in
                    Section(header: Text(date.formatted(date: .long, time: .omitted))) {
                        ForEach(groupedWords[date] ?? []) { word in
                            HStack {
                                Text(word.word).bold()
                                Text("–")
                                Text(word.translation)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Dictionary 📖")
            .searchable(text: $searchText, prompt: "Search Words")
            .overlay {
                
                if filteredWords.isEmpty {
                    if searchText.isEmpty {
                        ContentUnavailableView(
                            "The dictionary is empty",
                            systemImage: "text.book.closed",
                            description: Text("Add words to your lessons and they will appear here.")
                        )
                    } else {
                        ContentUnavailableView.search(text: searchText)
                    }
                }
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
        let word2 = VocabularyWord(word: "Example", translation: "Пример")
        
        container.mainContext.insert(lesson)
        container.mainContext.insert(word1)
        container.mainContext.insert(word2)
        
        lesson.vocabulary = [word1, word2]
        word1.lesson = lesson
        word2.lesson = lesson
        
        return container
    }()

    DictionaryView()
        .modelContainer(container)
}



