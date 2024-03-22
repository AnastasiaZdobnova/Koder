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
    func numberOfEmployees(inCategory category: String, search: String) -> Int
    func getEmployeesInCategory(inCategory category: String, sort: String, search: String) -> [Employee]
    func getUpcomingBirthdays(inCategory category: String, sort: String, search: String) -> [Employee]
    func getPastBirthdays(inCategory category: String, sort: String, search: String) -> [Employee]
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
    
    func numberOfEmployees(inCategory category: String, search: String) -> Int {
       
        return filterSearch(search: search, category: category).count
    }

    func getEmployeesInCategory(inCategory category: String, sort: String, search: String) -> [Employee] {
        var filteredEmployees: [Employee] = []
        // Фильтрация сотрудников по строке поиска и категории
        filteredEmployees = filterSearch(search: search, category: category)

        // Сортировка сотрудников
        if sort == "По алфавиту" {
            return filteredEmployees.sorted { $0.firstName.lowercased() < $1.firstName.lowercased() }
        } else {
            // Сортировка по дню рождения
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd"
            let today = Date()
            let currentMonthDay = dateFormatter.string(from: today)

            let sortedEmployees = filteredEmployees.sorted {
                let birthday1 = String($0.birthday.dropFirst(5))
                let birthday2 = String($1.birthday.dropFirst(5))
                return birthday1 < birthday2
            }

            // Разделение на тех, кто уже отмечал день рождения в этом году, и тех, кто ещё нет
            let upcomingBirthdays = sortedEmployees.filter { String($0.birthday.dropFirst(5)) >= currentMonthDay }
            let pastBirthdays = sortedEmployees.filter { String($0.birthday.dropFirst(5)) < currentMonthDay }

            // Объединение двух массивов, так что предстоящие дни рождения идут первыми
            return upcomingBirthdays + pastBirthdays
        }
    }
    
    func getUpcomingBirthdays(inCategory category: String, sort: String, search: String) -> [Employee]{
        var filteredEmployees: [Employee] = []
        // Фильтрация сотрудников по строке поиска и категории
        filteredEmployees = filterSearch(search: search, category: category)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        let today = Date()
        let currentMonthDay = dateFormatter.string(from: today)

        let sortedEmployees = filteredEmployees.sorted {
            let birthday1 = String($0.birthday.dropFirst(5))
            let birthday2 = String($1.birthday.dropFirst(5))
            return birthday1 < birthday2
        }

        // Разделение на тех, кто уже отмечал день рождения в этом году, и тех, кто ещё нет
        let upcomingBirthdays = sortedEmployees.filter { String($0.birthday.dropFirst(5)) >= currentMonthDay }
        return upcomingBirthdays
    }
    
    func getPastBirthdays(inCategory category: String, sort: String, search: String) -> [Employee]{
        var filteredEmployees: [Employee] = []
        // Фильтрация сотрудников по строке поиска и категории
        filteredEmployees = filterSearch(search: search, category: category)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        let today = Date()
        let currentMonthDay = dateFormatter.string(from: today)

        let sortedEmployees = filteredEmployees.sorted {
            let birthday1 = String($0.birthday.dropFirst(5))
            let birthday2 = String($1.birthday.dropFirst(5))
            return birthday1 < birthday2
        }
        
        let pastBirthdays = sortedEmployees.filter { String($0.birthday.dropFirst(5)) < currentMonthDay }
        return pastBirthdays
    }
    
    
    
    private func filterSearch(search: String, category: String) -> [Employee] {
        
        var filteredEmployees = employees
        
        if !search.isEmpty {
            filteredEmployees = employees.filter { employee in
                employee.firstName.lowercased().contains(search.lowercased()) ||
                employee.lastName.lowercased().contains(search.lowercased()) ||
                employee.userTag.lowercased().contains(search.lowercased())
            }
        }
        
        if category == "Все" {
            return filteredEmployees
        } else {
            // Найти соответствующий rawValue для категории
            if let departmentRawValue = departments.first(where: { $0.1 == category })?.0 {
                filteredEmployees = filteredEmployees.filter { $0.department.rawValue == departmentRawValue }
                return filteredEmployees
            }
        }
        return filteredEmployees
    }
}
