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
}
