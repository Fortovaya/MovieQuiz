import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
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
        
        resetImageBorder()
        
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
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func resetImageBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func blockButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
        noButton.alpha = isEnabled ? 1.0 : 0.5
        yesButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func showLoadingIndicator(){
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator(){
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать ещё раз", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

