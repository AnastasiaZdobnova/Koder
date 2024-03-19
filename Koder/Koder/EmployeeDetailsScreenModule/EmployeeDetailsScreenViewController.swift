//
//  EmployeeDetailsScreenViewController.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation
import UIKit
import SnapKit

protocol EmployeeDetailsScreenViewControllerProtocol : UIViewController {
    var employeeDetailsPresenter: EmployeeDetailsScreenPresenterProtocol { get }
}

class EmployeeDetailsViewController: UIViewController, EmployeeDetailsScreenViewControllerProtocol {
    
    var employeeDetailsPresenter: EmployeeDetailsScreenPresenterProtocol
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 104/2 // Половина высоты и ширины для круглой формы\
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let userTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let contentWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6 // TODO: вынести отдельно
        navigationController?.isNavigationBarHidden = false
        configure(with: employeeDetailsPresenter.employeeDetailsScreenModel.employee)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(positionLabel)
        view.addSubview(userTagLabel)
        view.addSubview(contentWhiteView)
        setupConstraints()
    }
    
    init(presenter: EmployeeDetailsScreenPresenterProtocol) {
        self.employeeDetailsPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(104)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        positionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
        }
        
        userTagLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(4)
        }
        
        contentWhiteView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(positionLabel.snp.bottom).offset(24)
        }
    }
    
    public func configure(with employee: Employee) {
        nameLabel.text = "\(employee.firstName) \(employee.lastName)"
        positionLabel.text = employee.position
        userTagLabel.text = employee.userTag.lowercased()
        
        if let url = URL(string: employee.avatarUrl) {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        // Здесь должна быть ваша логика загрузки изображений,
        // например, с использованием URLSession или библиотеки для кэширования изображений, такой как SDWebImage
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
        task.resume()
    }
}
