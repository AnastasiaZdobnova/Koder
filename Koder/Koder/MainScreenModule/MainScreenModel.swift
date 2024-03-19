//
//  MainScreenModel.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation

protocol MainScreenModelProtocol: AnyObject {
    var departments: [(String, String)] { get }
}

final class MainScreenModel: MainScreenModelProtocol {

    weak var mainPresenter: MainScreenPresenterProtocol?

    var departments = [
        ("android", "Android"),
        ("ios", "iOS"),
        ("design", "Дизайн"),
        ("management", "Менеджмент"),
        ("qa", "QA"),
        ("back_office", "Бэк-офис"),
        ("frontend", "Frontend"),
        ("hr", "HR"),
        ("pr", "PR"),
        ("backend", "Backend"),
        ("support", "Техподдержка"),
        ("analytics", "Аналитика")
    ]
}
