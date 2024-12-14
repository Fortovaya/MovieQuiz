//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Алина on 14.12.2024.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        return self.correct > another.correct
    }
}
