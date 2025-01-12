import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    //MARK: - Variables
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers: Int = .zero
    private var questionFactory: QuestionFactoryProtocol?
    
    var alertPresenter: ResultAlertPresenter?
    private var statisticService: StatisticServiceProtocol?
    
    private let presenter = MovieQuizPresenter()
    private var currentQuestion: QuizQuestion?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.backgroundColor = .clear
        textLabel.text = ""
        counterLabel.text = ""
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        alertPresenter = ResultAlertPresenter(viewController: self)
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        guard let questionFactory = questionFactory else { return }
        questionFactory.loadData()
        
        activityIndicator.hidesWhenStopped = true
        showLoadingIndicator()
        
        presenter.viewController = self
    }
    
    // MARK: - Стиль статус-бара
       override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
    //MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
            presenter.didReceiveNextQuestion(question: question)
        }

    //MARK: - @IBAction
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    //MARK: - private func
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
            
            
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
//    private func showNextQuestionOrResults() {
//        if presenter.isLastQuestion() {
//            guard let statisticService = statisticService else { return }
//            statisticService.store(correct: correctAnswers, total:presenter.questionsAmount)
//            
//            let message = getGamesStatistic(correct: correctAnswers, total: presenter.questionsAmount)
//            let alertModel = AlertModel(title: "Этот раунд окончен",
//                                        message: message,
//                                        buttonText: "Сыграть еще раз",
//                                        completion: { [weak self] in
//                self?.presenter.resetQuestionIndex()
//                self?.correctAnswers = .zero
//                guard let questionFactory = self?.questionFactory else { return }
//                questionFactory.requestNextQuestion()
//            }
//            )
//            
//            guard let alertPresenter else { return }
//            alertPresenter.showAlert(with: alertModel)
//        } else {
//            presenter.switchToNextQuestion()
//            guard let questionFactory = questionFactory else { return }
//            questionFactory.requestNextQuestion()
//        }
//    }
//    
//    private func getGamesStatistic(correct count: Int, total amount: Int) -> String {
//        guard let statisticService = statisticService else { return "Ваш результат: \(count)/\(amount)"}
//        
//        let score = "Ваш результат: \(count)/\(amount)"
//        let gamesCount = "Количество сыгранных квизов: \(statisticService.gamesCount)"
//        let record = "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))"
//        let totalAccuracy = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
//        
//        return [score, gamesCount, record, totalAccuracy].joined(separator: "\n")
//    }
    
    private func blockButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
        noButton.alpha = isEnabled ? 1.0 : 0.5
        yesButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        alertPresenter?.closeAlert()
        questionFactory?.requestNextQuestion()
    }
    
    // отображение индикатора
    private func showLoadingIndicator(){
        activityIndicator.startAnimating()
    }
    //скрытие индикатора
    private func hideLoadingIndicator(){
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        self.presenter.resetQuestionIndex()
        self.correctAnswers = 0
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.questionFactory?.loadData()
        }
        
        alertPresenter?.showAlert(with: model)
    }
}

