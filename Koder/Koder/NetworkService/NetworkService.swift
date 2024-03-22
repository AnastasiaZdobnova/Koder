//
//  NetworkService.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchEmployees(completion: @escaping (Result<EmployeeResponse, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    private let baseUrl = URL(string: "https://stoplight.io/mocks/kode-api/trainee-test/331141861/users")!
    private var requestDelay: TimeInterval = 2
    private var preferHeaderValues: [ResponseType: String] = [
        .success: "code=200, example=success",
        .error: "code=500, example=error-500"
    ]
    private var currentPreferHeader: String {
        preferHeaderValues[currentResponseType] ?? "code=200, example=success"
    }
    
    private var currentResponseType: ResponseType = .success // Тут указываем  error или success


    func fetchEmployees(completion: @escaping (Result<EmployeeResponse, Error>) -> Void) {
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(currentPreferHeader, forHTTPHeaderField: "Prefer")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.requestDelay) {
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
        }
        task.resume()
    }

    enum ResponseType {
        case success
        case error
    }
}
