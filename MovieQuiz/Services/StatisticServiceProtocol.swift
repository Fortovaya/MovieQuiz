//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Алина on 14.12.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get } // кол-во завершенных игр
    var bestGame: GameResult { get } // информация о лучшей попытке
    var totalAccuracy: Double { get } // средняя точность правильных ответов за все игры в процентах
    
    // метод сохранения текущего результата игры
    func store(correct count: Int, total amount: Int)
}
