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
    func getEmployeesInCategory(atIndex index: Int, category: String, sort: String, search: String, section: Int) -> Employee
    func getPastBirthdays(inCategory category: String, sort: String, search: String) -> [Employee]
    func showEmployeeDetailScreen(for employee: Employee)
    func showFilterBottomSheet(selectedSort: String)
    func numberOfRowsInSection(inCategory: String, sort: String, search: String, section: Int) -> Int
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    
    var mainScreenModel: MainScreenModelProtocol
    private let requestDelay: TimeInterval = 1
    
    weak var mainViewController: MainScreenViewController?
    weak var navigationController: UINavigationController?
    
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
                    self?.mainScreenModel.employees = employees
                    self?.mainViewController?.updateUI(with: employees)
                case .failure(let error):
                    if self?.mainViewController!.isDataLoaded == true {
                        self?.mainViewController?.endRefreshing()
                    }
                    else{
                        let errorView = FatalErrorViewController()
                        self?.navigationController?.pushViewController(errorView, animated: true)
                    }
                }
            }
        }
    }
    
    private func numberOfEmployees(selectedCategory: String, search: String) -> Int {
        return mainScreenModel.numberOfEmployees(inCategory: selectedCategory, search: search)
    }
    
    func getEmployeesInCategory(atIndex index: Int, category: String, sort: String, search: String, section: Int) -> Employee {
        if sort == "По алфавиту"{
            return mainScreenModel.getEmployeesInCategory(inCategory: category, sort: sort, search: search)[index]
        }
        else{
            let employeeGroup = section == 0 ? getUpcomingBirthdays(inCategory: category, sort: sort, search: search) : getPastBirthdays(inCategory: category, sort: sort, search: search)
            return employeeGroup[index]
        }
    }
    
    private func getUpcomingBirthdays(inCategory category: String, sort: String, search: String) -> [Employee]{
        return mainScreenModel.getUpcomingBirthdays(inCategory: category, sort: sort, search: search)
    }
    
    func getPastBirthdays(inCategory category: String, sort: String, search: String) -> [Employee]{
        return mainScreenModel.getPastBirthdays(inCategory: category, sort: sort, search: search)
    }
    
    func showEmployeeDetailScreen(for employee: Employee) {
        // Создаем экран с детальной информацией о сотруднике
        let model = EmployeeDetailsScreenModel(employee: employee)
        let presenter = EmployeeDetailsPresenter(model: model)
        let view = EmployeeDetailsViewController(presenter: presenter)
        
        model.employeeDetailsPresenter = presenter
        presenter.employeeDetailsViewController = view
        
        navigationController?.pushViewController(view, animated: true)
    }
    
    func showFilterBottomSheet(selectedSort: String) {
        
        let model = FilterBottomSheetModel()
        let presenter = FilterBottomSheetPresenter(model: model)
        let bottomSheetVC = FilterBottomSheetViewController(presenter: presenter, selectedSort: selectedSort)
        
        model.filterBottomSheetPresenter = presenter
        presenter.filterBottomSheetController = bottomSheetVC
        bottomSheetVC.delegate = mainViewController
        bottomSheetVC.modalPresentationStyle = .pageSheet
        bottomSheetVC.modalTransitionStyle = .coverVertical
        mainViewController?.showBottomSheet(bottomSheetVC)
    }
    
    func numberOfRowsInSection(inCategory: String, sort: String, search: String, section: Int) -> Int {
        var number = 0
        if sort == "По алфавиту"{
            number = numberOfEmployees(selectedCategory: inCategory, search: search)
        }
        else {
            if section == 0 {
                number = getUpcomingBirthdays(inCategory: inCategory, sort: sort, search: search).count
            }
            else{
                number = getPastBirthdays(inCategory: inCategory, sort: sort, search: search).count
            }
        }
        
        return number
    }
}
