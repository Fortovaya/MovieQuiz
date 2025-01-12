import UIKit

final class MovieQuizViewController: UIViewController {
    //MARK: - Variables
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!

    var alertPresenter: ResultAlertPresenter?
    private var statisticService: StatisticServiceProtocol?
    
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
        statisticService = StatisticServiceImplementation()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        activityIndicator.hidesWhenStopped = true
        showLoadingIndicator()
    }
    
    // MARK: - Стиль статус-бара
       override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
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

    
//    func show(quiz result: QuizResultsViewModel) {
//            imageView.image = result.image
//            textLabel.text = result.question
//            counterLabel.text = result.questionNumber
//            
//            let currentGameResultLine = "Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)"
//            // Отображаем результат игры
//            
//            if let statisticService = statisticService {
//                statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
//            }
//            
//            let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
//                self?.presenter.restartGame()
//                self?.questionFactory?.loadData()
//            }
//        }
    
    
    func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func showNextQuestionOrResults() {
            if presenter.isLastQuestion() {
                let text = presenter.getGamesStatistic(correct: presenter.correctAnswers, total: presenter.questionsAmount)
                // Отобразить информацию о завершении игры
            }
        }
    
    private func blockButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
        noButton.alpha = isEnabled ? 1.0 : 0.5
        yesButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    // отображение индикатора
    func showLoadingIndicator(){
        activityIndicator.startAnimating()
    }
    //скрытие индикатора
    func hideLoadingIndicator(){
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        
        alertPresenter?.showAlert(with: model)
    }
}

