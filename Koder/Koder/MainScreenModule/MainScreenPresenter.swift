//
//  MainScreenPresenter.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation
import UIKit

protocol MainScreenPresenterProtocol: AnyObject {
    var mainScreenModel : MainScreenModelProtocol { get set }
    func getDepartmentNames() -> [String]
    func fetchEmployees()
    func numberOfEmployees(selectedCategory: String) -> Int
    func getEmployeesInCategory(atIndex index: Int, category: String) -> Employee
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    
    var mainScreenModel: MainScreenModelProtocol
    
    weak var mainViewController: MainScreenViewController?
    
    init(model: MainScreenModelProtocol) {
        self.mainScreenModel = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getDepartmentNames() -> [String] {
        return mainScreenModel.departments.map { $0.1 } // Извлекаем только названия департаментов
    }
    
    func fetchEmployees() {
        mainScreenModel.fetchEmployees { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let employees):
                    self?.mainScreenModel.employees = employees // Обновляем данные в модели
                    self?.mainViewController?.updateUI(with: employees)
                case .failure(let error):
                    // Обработка ошибки, например, показать UIAlert с ошибкой
                    print("Error fetching employees: \(error)")
                }
            }
        }
    }
    
    func numberOfEmployees(selectedCategory: String) -> Int {
        return mainScreenModel.numberOfEmployees(inCategory: selectedCategory)
    }
    
    func getEmployeesInCategory(atIndex index: Int, category: String) -> Employee {
        return mainScreenModel.getEmployeesInCategory(inCategory: category)[index]
    }
}
