//
//  EmployeeTableViewCell.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation
import SnapKit
import SkeletonView

class EmployeeTableViewCell: UITableViewCell {
    
    static let identifier = "EmployeeTableViewCell"
    private var nameLabelRightConstraint: Constraint?
    
    private let contentWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 72/2 // Половина высоты и ширины для круглой формы\
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let nameLabelSkeleton: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.isSkeletonable = true
        label.skeletonTextNumberOfLines = 1
        label.skeletonTextLineHeight = .fixed(16)
        label.linesCornerRadius = 8
        return label
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .darkGray
        label.isSkeletonable = true
        label.skeletonTextNumberOfLines = 1
        label.skeletonTextLineHeight = .fixed(12)
        label.linesCornerRadius = 6
        return label
    }()
    
    private let userTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        contentView.addSubview(contentWhiteView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(positionLabel)
        contentView.addSubview(userTagLabel)
        contentView.addSubview(nameLabelSkeleton)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentWhiteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(contentWhiteView).offset(6) // Изменение отступа сверху
            make.bottom.equalTo(contentWhiteView).inset(6) // Изменение отступа снизу
            make.width.height.equalTo(72)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentWhiteView).offset(22)
            make.left.equalTo(avatarImageView.snp.right).offset(16)
        }
        
        nameLabelSkeleton.snp.makeConstraints { make in
            make.edges.equalTo(nameLabel)
            make.width.equalTo(144)
        }
        
        positionLabel.snp.makeConstraints { make in
            make.top.equalTo(contentWhiteView).offset(45)
            make.left.equalTo(nameLabel.snp.left)
            make.width.equalTo(80)
        }
        
        userTagLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(4)
        }
    }
    
    public func configure(with employee: Employee?) {
        if let employee = employee {
            
            nameLabel.text = "\(employee.firstName) \(employee.lastName)"
            positionLabel.text = employee.position
            userTagLabel.text = employee.userTag.lowercased()
            
            if let url = URL(string: employee.avatarUrl) {
                loadImage(from: url)
            }
        }
        else{
            
            nameLabel.text = nil
            positionLabel.text = nil
            userTagLabel.text = nil
            avatarImageView.image = nil
        }
    }
    
    private func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
        task.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        nameLabel.text = nil
        positionLabel.text = nil
        userTagLabel.text = nil
    }
}

