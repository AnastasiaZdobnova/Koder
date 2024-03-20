//
//  FilterBottomSheetPresenter.swift
//  Koder
//
//  Created by Анастасия Здобнова on 20.03.2024.
//

import Foundation
import UIKit

protocol FilterBottomSheetPresenterProtocol: AnyObject {
    var filterBottomSheetModel : FilterBottomSheetModelProtocol { get set }
}

final class FilterBottomSheetPresenter: FilterBottomSheetPresenterProtocol {

    var filterBottomSheetModel: FilterBottomSheetModelProtocol

    weak var filterBottomSheetController: FilterBottomSheetViewController?

    init(model: FilterBottomSheetModelProtocol) {
        self.filterBottomSheetModel = model
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
