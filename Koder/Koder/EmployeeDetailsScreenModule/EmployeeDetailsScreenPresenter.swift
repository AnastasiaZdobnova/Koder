//
//  EmployeeDetailsScreenPresenter.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation
import UIKit

protocol EmployeeDetailsScreenPresenterProtocol: AnyObject {
    var employeeDetailsScreenModel : EmployeeDetailsScreenModelProtocol { get set }
    func makeCall()
    func getEmployee() -> Employee
    func formattedBirthday() -> String
    func ageDescription() -> String
}

final class EmployeeDetailsPresenter: EmployeeDetailsScreenPresenterProtocol {
    
    var employeeDetailsScreenModel: EmployeeDetailsScreenModelProtocol
    
    weak var employeeDetailsViewController: EmployeeDetailsScreenViewControllerProtocol?
    
    init(model: EmployeeDetailsScreenModelProtocol) {
        self.employeeDetailsScreenModel = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeCall() { 
        if let url = URL(string: "tel://\(employeeDetailsScreenModel.employee.phone)") {
            UIApplication.shared.open(url)
        }
    }
    
    func getEmployee() -> Employee {
        return employeeDetailsScreenModel.getEmployee()
    }
    
    func formattedBirthday() -> String {
        return employeeDetailsScreenModel.formattedBirthday()
    }
    
    func ageDescription() -> String {
        return employeeDetailsScreenModel.ageDescription()
    }
}
