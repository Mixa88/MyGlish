//
//  Lesson.swift
//  MyGlish
//
//  Created by Михайло Тихонов on 04.09.2025.
//

import Foundation
import SwiftData

@Model
class Lesson {
    var date: Date
    var topic: String
    var durationInMinutes: Int
    
    var grammarTopics: String?
    var homework: String?
    
    @Attribute(.externalStorage) var notes: String?
    
    @Relationship(deleteRule: .nullify, inverse: \VocabularyWord.lesson)
        var vocabulary: [VocabularyWord] = []
    
    init(date: Date, topic: String, durationInMinutes: Int = 60, grammarTopics: String? = nil, homework: String? = nil, notes: String? = nil) {
        self.date = date
        self.topic = topic
        self.durationInMinutes = durationInMinutes
        self.grammarTopics = grammarTopics
        self.homework = homework
        self.notes = notes
    }
    
}

@Model
class VocabularyWord {
    
    @Attribute(.unique) var word: String
    var translation: String
    var dateAdded: Date
    
    var lesson: Lesson?
    
    init(word: String, translation: String, dateAdded: Date) {
        self.word = word
        self.translation = translation
        self.dateAdded = dateAdded
    }
}
