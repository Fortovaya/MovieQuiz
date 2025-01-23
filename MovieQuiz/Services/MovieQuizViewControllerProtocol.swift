//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Алина on 12.01.2025.
//

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quiz step: QuizStepViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func resetImageBorder()
    func blockButton(isEnabled: Bool)
    func showAlert(with model: AlertModel)
}
