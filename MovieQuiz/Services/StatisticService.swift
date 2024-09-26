//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Irina Vasileva on 23.09.2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correctAnswers
        case bestGame
        case gamesCount
        
        enum BestGame: String {
            case correct
            case total
            case date
        }
    }
    // счетчик
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    // лучшая игра
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.BestGame.correct.rawValue)
            let total = storage.integer(forKey: Keys.BestGame.total.rawValue)
            let data = storage.object(forKey: Keys.BestGame.date.rawValue) as? Date ?? Date()
            let best = GameResult(correct: correct, total: total, date: data)
            return best
        }
        set {
            storage.set(newValue.correct, forKey: Keys.BestGame.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.BestGame.total.rawValue)
            storage.set(newValue.date, forKey: Keys.BestGame.date.rawValue)
        }
    }
    
    // правильные ответы
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    // средняя точность в процентах
    var totalAccuracy: Double {
        if gamesCount != 0 && correctAnswers != 0 {
            return (Double(correctAnswers)/(Double(bestGame.total * gamesCount))) * 100
        } else {
            return 0
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        correctAnswers += count
        gamesCount += 1
        let newGame = GameResult(correct: count, total: amount, date: Date())
        if  newGame.isBetterThan(bestGame) || newGame.isEqual(another: bestGame) {
            bestGame = newGame
        }
    }
    
}
