//
//  EmployeeDetailsScreenModel.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation

protocol EmployeeDetailsScreenModelProtocol: AnyObject {
    var employee: Employee { get }
    func getEmployee() -> Employee
    func formattedBirthday() -> String
    func ageDescription() -> String
}

final class EmployeeDetailsScreenModel: EmployeeDetailsScreenModelProtocol {
    weak var employeeDetailsPresenter: EmployeeDetailsScreenPresenterProtocol?
    let employee: Employee
    
    init(employee: Employee) {
        self.employee = employee
    }
    
    func getEmployee() -> Employee {
        return employee
    }
    
    func formattedBirthday() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let birthdayDate = dateFormatter.date(from: employee.birthday) {
            dateFormatter.dateStyle = .long
            dateFormatter.locale = Locale(identifier: "ru_RU")
            return dateFormatter.string(from: birthdayDate)
        }
        
        return "Неизвестная дата"
    }
    
    func ageDescription() -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let birthDate = dateFormatter.date(from: employee.birthday),
           let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date()).year {
            let age = ageComponents
            let yearsLastDigit = age % 10
            var suffix = "лет"
            
            if (age % 100 < 11) || (age % 100 > 14) {
                switch yearsLastDigit {
                case 1:
                    suffix = "год"
                case 2...4:
                    suffix = "года"
                default:
                    break
                }
            }
            
            return "\(age) \(suffix)"
        }
        
        return "Неизвестный возраст"
    }
}

