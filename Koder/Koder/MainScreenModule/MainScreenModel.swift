//
//  MainScreenModel.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation

protocol MainScreenModelProtocol: AnyObject {
    var departments: [(String, String)] { get }
    func fetchEmployees(completion: @escaping (Result<[Employee], Error>) -> Void)
}

final class MainScreenModel: MainScreenModelProtocol {

    weak var mainPresenter: MainScreenPresenterProtocol?

    var departments = [
        ("android", "Android"),
        ("ios", "iOS"),
        ("design", "Дизайн"),
        ("management", "Менеджмент"),
        ("qa", "QA"),
        ("back_office", "Бэк-офис"),
        ("frontend", "Frontend"),
        ("hr", "HR"),
        ("pr", "PR"),
        ("backend", "Backend"),
        ("support", "Техподдержка"),
        ("analytics", "Аналитика")
    ]
    
    func fetchEmployees(completion: @escaping (Result<[Employee], Error>) -> Void) {
        let networkService = NetworkService()
        networkService.fetchEmployees { result in
            switch result {
            case .success(let employeeResponse):
                completion(.success(employeeResponse.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
