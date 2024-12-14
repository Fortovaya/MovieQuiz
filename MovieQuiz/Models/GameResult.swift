//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Алина on 14.12.2024.
//

import Foundation

struct GameResult {
    let correct: Int // кол-во правильных ответов
    let total: Int // кол-во вопросов квиза
    let date: Date // дата завершения квиза
    
    // метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameResult) -> Bool {
        return self.correct > another.correct
    }
}
