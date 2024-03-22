//
//  DepartmentCell.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation
import UIKit
import SnapKit

class DepartmentCell: UICollectionViewCell {
    
    private var nameLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private var underlineView: UIView! = {
        let view = UIView()
        view.backgroundColor = AppColors.accentColor
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
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(underlineView)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.left.equalTo(contentView.snp.left).offset(12)
            make.right.equalTo(contentView.snp.right).inset(12)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
        }

        underlineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.left.right.bottom.equalTo(contentView)
        }
    }


    func configure(with name: String, isSelected: Bool) {
        nameLabel.text = name
        if isSelected == true {
            underlineView.isHidden = false
            nameLabel.textColor = AppColors.titleTextColor
            nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        else{
            underlineView.isHidden = true
            nameLabel.textColor = AppColors.subtitleTextColor
            nameLabel.font = UIFont.systemFont(ofSize: 15)
        }
    }
}

