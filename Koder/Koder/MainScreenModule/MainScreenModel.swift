//
//  MainScreenModel.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation

protocol MainScreenModelProtocol: AnyObject {
    var departments: [(String, String)] { get }
    var employees: [Employee] { get set }
    func fetchEmployees(completion: @escaping (Result<[Employee], Error>) -> Void)
    func numberOfEmployees(inCategory category: String) -> Int
    func getEmployeesInCategory(inCategory category: String) -> [Employee]
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
    
    var employees: [Employee] = []
    
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
    
    func numberOfEmployees(inCategory category: String) -> Int {
        if category == "Все" {
            return employees.count
        } else {
            // Найти соответствующий rawValue для категории
            if let departmentRawValue = departments.first(where: { $0.1 == category })?.0 {
                return employees.filter { $0.department.rawValue == departmentRawValue }.count
            }
        }
        return 0
    }

    func getEmployeesInCategory(inCategory category: String) -> [Employee] {
        if category == "Все" {
            return employees
        } else {
            // Найти соответствующий rawValue для категории
            if let departmentRawValue = departments.first(where: { $0.1 == category })?.0 {
                return employees.filter { $0.department.rawValue == departmentRawValue }
            }
        }
        return []
    }

}
