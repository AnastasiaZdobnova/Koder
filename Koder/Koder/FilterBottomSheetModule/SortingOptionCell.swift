//
//  SortingOptionCell.swift
//  Koder
//
//  Created by Анастасия Здобнова on 20.03.2024.
//

import Foundation
import SnapKit
import UIKit

class SortingOptionCell: UITableViewCell {
    static let identifier = "SortingOptionCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(12)
            make.left.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.centerY.equalTo(iconImageView)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        iconImageView.image = UIImage(named: isSelected ? "selected" : "unselected")
    }
    
}
