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
            switch result {
            case .success(let employees): // здесь employees уже массив Employee
                // Теперь employees это то, что вы ожидали получить в employeeResponse.items
                // Обновите интерфейс пользователя, передав список сотрудников
                //self?.mainViewController?.updateUI(with: employees)
                print(employees)
            case .failure(let error):
                // Показываем ошибку, используя mainViewController
                //self?.mainViewController?.showError(error)
                print("error")
            }
        }
    }

}
