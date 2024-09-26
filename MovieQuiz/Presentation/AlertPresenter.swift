//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Irina Vasileva on 20.09.2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    private weak var delegate: UIViewController?
    
    //    init(delegate: UIViewController?) {
    //        self.delegate = delegate
    //    }
    
    func presenter(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
    func setup(delegate: UIViewController) {
        self.delegate = delegate
    }
}
