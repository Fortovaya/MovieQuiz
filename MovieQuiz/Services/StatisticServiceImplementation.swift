//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Алина on 14.12.2024.
//

import Foundation

final class StatisticServiceImplementation {
    private let storage: UserDefaults = .standard
    
    enum Keys: String {
        case correctAnswers
        case gamesCount
        case bestGameСorrect
        case bestGameTotal
        case bestGameDate
        case totalAccuracy
    }
}

extension StatisticServiceImplementation: StatisticServiceProtocol {
    
    var correctAnswers: Int {
        get {
            return storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameСorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set(newValue) {
            storage.set(newValue.correct, forKey: Keys.bestGameСorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        Double(correctAnswers) / Double(gamesCount * 10) * 100.0
    }
    
    func store(correct count: Int, total amount: Int) {
        let newGame = GameResult(correct: count, total: amount, date: Date())
        if newGame.isBetterThan(bestGame) {
            bestGame = newGame
        }
        correctAnswers += count
        gamesCount += 1
    }
}
