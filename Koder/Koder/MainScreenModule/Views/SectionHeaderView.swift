//
//  SectionHeaderView.swift
//  Koder
//
//  Created by Анастасия Здобнова on 22.03.2024.
//

import Foundation
import UIKit
import SnapKit

class SectionHeaderView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    let leftLine : UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.headerSectionColor
        return view
    }()
    
    let rightLine : UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.headerSectionColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {

        addSubview(leftLine)
        addSubview(rightLine)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        leftLine.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalToSuperview()
            make.width.equalTo(72)
            make.height.equalTo(1)
        }
        
        rightLine.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview()
            make.width.equalTo(72)
            make.height.equalTo(1)
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
