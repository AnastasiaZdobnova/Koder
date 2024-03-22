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
    
    private var nameLabel: UILabel!
    private var underlineView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.left.equalTo(contentView.snp.left).offset(12)
            make.right.equalTo(contentView.snp.right).inset(12)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
        }

        underlineView = UIView()
        contentView.addSubview(underlineView)
        underlineView.backgroundColor = .purple // Или другой цвет для фиолетовой линии
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.left.right.bottom.equalTo(contentView)
        }
    }


    func configure(with name: String, isSelected: Bool) {
        nameLabel.text = name
        if isSelected == true {
            underlineView.isHidden = false
            nameLabel.textColor = .black
            nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        else{
            underlineView.isHidden = true
            nameLabel.textColor = .systemGray2
            nameLabel.font = UIFont.systemFont(ofSize: 15)
        }
    }
}

