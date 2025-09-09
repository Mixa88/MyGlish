//
//  DictionaryView.swift
//  MyGlish
//
//  Created by Михайло Тихонов on 07.09.2025.
//

import SwiftUI
import SwiftData

struct DictionaryView: View {
    
    @Query(sort: \VocabularyWord.dateAdded, order: .reverse) var words: [VocabularyWord]
    
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
    
    // ✅ ИЗМЕНЕНИЕ 1: Убираем фильтр. Теперь группируем ВСЕ слова.
    private var groupedWords: [Date: [VocabularyWord]] {
        return Dictionary(grouping: filteredWords) { word in
            Calendar.current.startOfDay(for: word.dateAdded)
        }
    }
    
    // Свойство orphanWords больше не нужно, его можно удалить.
    
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
                
                // ✅ ИЗМЕНЕНИЕ 2: Секция для "orphanWords" полностью удалена.
            }
            .navigationTitle("My Dictionary 📖")
            .searchable(text: $searchText, prompt: "Search Words")
            .overlay {
                if words.isEmpty {
                    ContentUnavailableView(
                        "The dictionary is empty",
                        systemImage: "text.book.closed",
                        description: Text("Add words to your lessons and they will appear here.")
                    )
                } else if filteredWords.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
            }
        }
    }
}

// MARK: - Preview (здесь ничего не меняется)
#Preview {
    
}



