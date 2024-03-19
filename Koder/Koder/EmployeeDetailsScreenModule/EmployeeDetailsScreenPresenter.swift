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
    
    func makeCall() { //employeeDetailsScreenModel.employee.phone
        if let url = URL(string: "tel://\(employeeDetailsScreenModel.employee.phone)") {
            UIApplication.shared.open(url)
        }
    }
}
