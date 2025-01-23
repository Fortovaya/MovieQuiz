//
//  MovieQuizPresenter.swift.swift
//  MovieQuiz
//
//  Created by Алина on 12.01.2025.
//
import UIKit

protocol MovieQuizPresenterProtocol {
    func yesButtonClicked()
    func noButtonClicked()
    func restartGame()
}

final class MovieQuizPresenter:MovieQuizPresenterProtocol, QuestionFactoryDelegate {
    
    private var currentQuestion: QuizQuestion?
    
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol
    
    private(set) var correctAnswers: Int = .zero
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = .zero
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        self.statisticService = StatisticServiceImplementation()
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory?.loadData()
        self.viewController?.showLoadingIndicator()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        viewController?.blockButton(isEnabled: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
            self.viewController?.blockButton(isEnabled: true)
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        
        viewController?.resetImageBorder()
        
        if self.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total:self.questionsAmount)
            
            let message = getGamesStatistic(correct: correctAnswers, total: self.questionsAmount)
            let alertModel = AlertModel(title: "Этот раунд окончен",
                                        message: message,
                                        buttonText: "Сыграть еще раз",
                                        completion: { [weak self] in
                self?.restartGame()
                self?.questionFactory?.requestNextQuestion()
            })
            viewController?.showAlert(with: alertModel)
        } else {
            self.switchToNextQuestion()
            guard let questionFactory = questionFactory else { return }
            questionFactory.requestNextQuestion()
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        viewController?.resetImageBorder()
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController?.show(quiz: viewModel)
        }
    }
    
    private func getGamesStatistic(correct count: Int, total amount: Int) -> String {
        
        let score = "Ваш результат: \(count)/\(amount)"
        let gamesCount = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let record = "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))"
        let totalAccuracy = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        return [score, gamesCount, record, totalAccuracy].joined(separator: "\n")
    }
    
    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        return getGamesStatistic(correct: correctAnswers, total: questionsAmount)
    }
}
