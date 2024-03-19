//
//  EmployeeDetailsScreenModel.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation

protocol EmployeeDetailsScreenModelProtocol: AnyObject {
    var employee: Employee { get }
}

final class EmployeeDetailsScreenModel: EmployeeDetailsScreenModelProtocol {
    weak var employeeDetailsPresenter: EmployeeDetailsScreenPresenterProtocol?
    let employee: Employee
    
    init(employee: Employee) {
        self.employee = employee
    }
}

