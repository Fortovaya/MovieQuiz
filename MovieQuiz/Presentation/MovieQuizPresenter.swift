//
//  MovieQuizPresenter.swift.swift
//  MovieQuiz
//
//  Created by Алина on 12.01.2025.
//
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = .zero
    var currentQuestion: QuizQuestion?
    
    weak var viewController: MovieQuizViewController?
    var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol = StatisticServiceImplementation()
    
    private(set) var correctAnswers: Int = .zero
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
    
    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
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
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            
            statisticService.store(correct: correctAnswers, total:self.questionsAmount)
            
            let message = getGamesStatistic(correct: correctAnswers, total: self.questionsAmount)
            let alertModel = AlertModel(title: "Этот раунд окончен",
                                        message: message,
                                        buttonText: "Сыграть еще раз",
                                        completion: { [weak self] in
                self?.restartGame()
                self?.questionFactory?.requestNextQuestion()
            }
            )
            
            guard let alertPresenter = viewController?.alertPresenter else { return }
            alertPresenter.showAlert(with: alertModel)
        } else {
            self.switchToNextQuestion()
            guard let questionFactory = questionFactory else { return }
            questionFactory.requestNextQuestion()
        }
    }
    
    func getGamesStatistic(correct count: Int, total amount: Int) -> String {
        let score = "Ваш результат: \(count)/\(amount)"
        let gamesCount = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let record = "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))"
        let totalAccuracy = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        return [score, gamesCount, record, totalAccuracy].joined(separator: "\n")
    }
    
    
  
    
    
    
    
   
    
 
    
 
    
   
}

