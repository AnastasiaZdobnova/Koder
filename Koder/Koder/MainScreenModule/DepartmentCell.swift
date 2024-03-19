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

        // Настройте стиль ячейки, например, фон, шрифт и т.д.
    }

    func configure(with name: String) {
        nameLabel.text = name
    }

    override var isSelected: Bool {
        didSet {
            // Измените стиль ячейки при выборе, например, добавьте фиолетовую полоску и сделайте текст жирным
        }
    }
}
