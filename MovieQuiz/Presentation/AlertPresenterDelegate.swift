//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Irina Vasileva on 25.09.2024.
//

import Foundation
protocol AlertPresenterDelegate: AnyObject {
    func setAlertModel() -> AlertModel
    func showNextQuestionOrResults()
}
