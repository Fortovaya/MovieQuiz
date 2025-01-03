//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Алина on 07.12.2024.
//

import UIKit

class ResultAlertPresenter: AlertPresenterProtocol {
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func showAlert(with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        
        alert.addAction(action)
        
        guard let delegate = delegate else { return }
        delegate.present(alert, animated: true, completion: nil)
    }
}
