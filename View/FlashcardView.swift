//
//  FlashcardView.swift
//  MyGlish
//
//  Created by Михайло Тихонов on 08.09.2025.
//

import SwiftUI
import SwiftData

struct FlashcardView: View {
    // 1. Запрашиваем все слова из базы
    @Query var allWords: [VocabularyWord]
    
    // 2. State для управления тренажером
    @State private var wordsToReview: [VocabularyWord] = []
    @State private var currentIndex = 0
    @State private var isFlipped = false
    
    // State для анимации
    @State private var rotation: Double = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                if wordsToReview.isEmpty {
                    ContentUnavailableView(
                        "Нет слов для изучения",
                        systemImage: "text.book.closed",
                        description: Text("Сначала добавьте слова к урокам.")
                    )
                } else {
                    // Прогресс бар (бонус)
                    ProgressView(value: Double(currentIndex), total: Double(wordsToReview.count))
                        .progressViewStyle(.linear)
                    
                    // 3. Сама карточка
                    ZStack {
                        // Используем два разных View для переда и зада, чтобы анимация была плавной
                        if !isFlipped {
                            CardFace(text: currentWord.word) // Передняя сторона
                        } else {
                            CardFace(text: currentWord.translation, isFront: false) // Задняя сторона
                        }
                    }
                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                    .onTapGesture {
                        flipCard()
                    }
                    
                    // 4. Кнопки управления
                    HStack(spacing: 20) {
                        Button("Shuffle Deck", systemImage: "shuffle", action: shuffleDeck)
                            .buttonStyle(.bordered)

                        Button("Next Word", systemImage: "arrow.right.circle.fill", action: nextWord)
                            .buttonStyle(.borderedProminent)
                    }
                }
            }
            .padding()
            .navigationTitle("Flashcards 🃏")
            .onAppear(perform: shuffleDeck) // Перемешиваем колоду при первом появлении
        }
    }
    
    // MARK: - Helper Properties & Functions
    
    private var currentWord: VocabularyWord {
        
        wordsToReview.indices.contains(currentIndex) ? wordsToReview[currentIndex] : VocabularyWord(word: "Done", translation: "Готово")
    }
    
    private func flipCard() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            rotation += 180
            isFlipped.toggle()
        }
    }
    
    private func nextWord() {
        
        if isFlipped {
            rotation += 180
            isFlipped = false
        }
        
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                if currentIndex < wordsToReview.count - 1 {
                    currentIndex += 1
                } else {
                    // Если дошли до конца, можно перемешать заново
                    shuffleDeck()
                }
            }
        }
    }
    
    private func shuffleDeck() {
        wordsToReview = allWords.shuffled()
        currentIndex = 0
        isFlipped = false
        rotation = 0
    }
}


struct CardFace: View {
    let text: String
    var isFront: Bool = true
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(isFront ? Color.primary : Color.white)
            .frame(maxWidth: .infinity, minHeight: 250)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .fill(isFront ? Color(.systemBackground) : Color.blue)
                    .shadow(radius: 8)
            }
            .rotation3DEffect(.degrees(isFront ? 0 : 180), axis: (x: 0, y: 1, z: 0))
    }
}

// MARK: - Preview
#Preview {
    // Используем наш надежный способ для превью
    let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Lesson.self, VocabularyWord.self, configurations: config)
        
        let lesson = Lesson(date: .now, topic: "Preview Lesson")
        let word1 = VocabularyWord(word: "Apple", translation: "Яблоко")
        let word2 = VocabularyWord(word: "House", translation: "Дом")
        
        container.mainContext.insert(lesson)
        container.mainContext.insert(word1)
        container.mainContext.insert(word2)
        
        lesson.vocabulary = [word1, word2]
        word1.lesson = lesson
        word2.lesson = lesson
        
        return container
    }()

    FlashcardView()
        .modelContainer(container)
}
