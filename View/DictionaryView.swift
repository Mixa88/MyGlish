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
    
    private var groupedWords: [Date: [VocabularyWord]] {
        let validWords = words.filter { $0.lesson != nil }
        return Dictionary(grouping: validWords) { word in
            Calendar.current.startOfDay(for: word.lesson?.date ?? .distantPast)
        }
    }
    
    private var sortedDates: [Date] {
        groupedWords.keys.sorted(by: >)
    }

    var body: some View {
        NavigationStack {
            if groupedWords.isEmpty {
                ContentUnavailableView(
                    "Словарь пуст",
                    systemImage: "text.book.closed",
                    description: Text("Добавьте слова к урокам, и они появятся здесь.")
                )
                .navigationTitle("My Dictionary 📖") // Заголовок для пустого состояния
            } else {
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
                .navigationTitle("My Dictionary 📖") // Заголовок для списка
            }
        }
    }
}



