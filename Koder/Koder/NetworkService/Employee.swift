//
//  Employee.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation

struct EmployeeResponse: Codable {
    let items: [Employee]
}

// Структура для отдельного пользователя
struct Employee: Codable {
    let id: String
    let avatarUrl: String
    let firstName: String
    let lastName: String
    let userTag: String
    let department: Department
    let position: String
    let birthday: String
    let phone: String
}

// Перечисление, представляющее допустимые значения для отделов
enum Department: String, Codable {
    case android
    case ios
    case design
    case management
    case qa
    case backOffice = "back_office"
    case frontend
    case hr
    case pr
    case backend
    case support
    case analytics
}
