//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Алина on 07.12.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
