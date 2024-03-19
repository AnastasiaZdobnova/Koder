//
//  MainScreenModel.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation

protocol MainScreenModelProtocol: AnyObject {
}

final class MainScreenModel: MainScreenModelProtocol {

    weak var mainPresenter: MainScreenPresenterProtocol?

}
