//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Irina Vasileva on 07.10.2024.
//

import Foundation
protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
// Отвечает за загрузку данных по URL
struct NetworkClient: NetworkRouting {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        // создаем запрос
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // проверяем, что нам пришел успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}
