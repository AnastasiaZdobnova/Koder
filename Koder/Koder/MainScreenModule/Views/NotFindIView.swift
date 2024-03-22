//
//  NotFindIView.swift
//  Koder
//
//  Created by Анастасия Здобнова on 22.03.2024.
//

import Foundation
import UIKit
import SnapKit

class NotFindIView: UIView {
    
    private let notFindImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "glass")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Мы никого не нашли"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = AppColors.titleTextColor
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Попробуй скорректировать запрос"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = AppColors.subtitleTextColor
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(notFindImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        notFindImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(notFindImageView.snp.bottom).offset(8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
    }
}
