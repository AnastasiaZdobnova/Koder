//
//  FilterBottomSheetModel.swift
//  Koder
//
//  Created by Анастасия Здобнова on 20.03.2024.
//

import Foundation

protocol FilterBottomSheetModelProtocol: AnyObject {
    var sortOptions: [String] { get }
}

final class FilterBottomSheetModel: FilterBottomSheetModelProtocol {

    weak var filterBottomSheetPresenter: FilterBottomSheetPresenterProtocol?
    
    let sortOptions = ["По алфавиту", "По дню рождения"]

}
