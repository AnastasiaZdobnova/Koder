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
}
