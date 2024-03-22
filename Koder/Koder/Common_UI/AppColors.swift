//
//  AppColors.swift
//  Koder
//
//  Created by Анастасия Здобнова on 22.03.2024.
//

import Foundation
import Foundation
import UIKit

struct AppColors {
    static let backgroundAppColor = UIColor.white
    static let accentColor = UIColor(hex: "6534FF") 
    static let textFieldColor = UIColor(hex: "#F7F7F8")
    static let titleTextColor = UIColor(hex: "#050510")
    static let subtitleTextColor = UIColor(hex: "#97979B")
    static let darkSubtitleColor = UIColor(hex: "55555C")
    static let headerSectionColor = UIColor(hex: "C3C3C6")
    static let skeletonColor = UIColor(hex: "F3F3F6")
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
