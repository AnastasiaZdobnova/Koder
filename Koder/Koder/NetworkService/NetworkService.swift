//
//  NetworkService.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation
protocol NetworkServiceProtocol {
}

// Реализация сетевого сервиса
class NetworkService {
    private let baseUrl = URL(string: "https://stoplight.io/mocks/kode-api/trainee-test/331141861/users")!
    private var preferHeaderValue: String = "code=200, example=success"

    // Устанавливаем тип ответа, который хотим получить
    func setResponseType(_ type: ResponseType) {
        switch type {
        case .success:
            preferHeaderValue = "code=200, example=success"
        case .error:
            preferHeaderValue = "code=500, example=error-500"
        }
    }

    // Функция для получения данных сотрудников
    func fetchEmployees(completion: @escaping (Result<EmployeeResponse, Error>) -> Void) {
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(preferHeaderValue, forHTTPHeaderField: "Prefer")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1001, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(EmployeeResponse.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    enum ResponseType {
        case success
        case error
    }
}
