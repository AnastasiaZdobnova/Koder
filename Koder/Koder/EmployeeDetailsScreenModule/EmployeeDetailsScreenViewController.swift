//
//  EmployeeDetailsScreenViewController.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

protocol EmployeeDetailsScreenViewControllerProtocol : UIViewController {
    var employeeDetailsPresenter: EmployeeDetailsScreenPresenterProtocol { get }
    func configureView(with employee: Employee)
}

class EmployeeDetailsViewController: UIViewController, EmployeeDetailsScreenViewControllerProtocol {
    
    var employeeDetailsPresenter: EmployeeDetailsScreenPresenterProtocol
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 104/2 // Половина высоты и ширины для круглой формы
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = AppColors.titleTextColor
        return label
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColors.darkSubtitleColor
        return label
    }()
    
    private let userTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppColors.subtitleTextColor
        return label
    }()
    
    private let contentWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.backgroundAppColor
        return view
    }()
    
    private let starIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let phoneIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "phone")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.titleTextColor
        return label
    }()
    
    private lazy var callButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.titleTextColor
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.subtitleTextColor
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.textFieldColor
        configureNavigationBar()
        configureView(with: employeeDetailsPresenter.getEmployee())
        setupUI()
    }
    
    init(presenter: EmployeeDetailsScreenPresenterProtocol) {
        self.employeeDetailsPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(positionLabel)
        view.addSubview(userTagLabel)
        view.addSubview(contentWhiteView)
        contentWhiteView.addSubview(phoneIconImageView)
        contentWhiteView.addSubview(starIconImageView)
        contentWhiteView.addSubview(phoneLabel)
        contentWhiteView.addSubview(callButton)
        contentWhiteView.addSubview(birthdayLabel)
        contentWhiteView.addSubview(ageLabel)
        setupConstraints()
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
            make.firstBaseline.equalTo(nameLabel.snp.firstBaseline)
            make.left.equalTo(nameLabel.snp.right).offset(4)
        }
        
        contentWhiteView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(positionLabel.snp.bottom).offset(24)
        }
        
        starIconImageView.snp.makeConstraints { make in
            make.top.equalTo(contentWhiteView).offset(28)
            make.left.equalTo(contentWhiteView).offset(18)
            make.width.height.equalTo(20)
        }
        
        birthdayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starIconImageView)
            make.left.equalTo(starIconImageView.snp.right).offset(14)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(birthdayLabel)
            make.right.equalTo(contentWhiteView).inset(20)
        }
        
        phoneIconImageView.snp.makeConstraints { make in
            make.left.equalTo(starIconImageView)
            make.top.equalTo(starIconImageView.snp.bottom).offset(48)
            make.width.height.equalTo(20)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.centerY.equalTo(phoneIconImageView)
            make.left.equalTo(phoneIconImageView.snp.right).offset(14)
        }
        
        callButton.snp.makeConstraints { make in
            make.centerY.equalTo(phoneIconImageView)
            make.left.right.equalTo(contentWhiteView)
            make.height.equalTo(60)
        }
        
    }
    
    func configureView(with employee: Employee) {
        nameLabel.text = "\(employee.firstName) \(employee.lastName)"
        positionLabel.text = employee.position
        userTagLabel.text = employee.userTag.lowercased()
        phoneLabel.text = employee.phone
        birthdayLabel.text = employeeDetailsPresenter.formattedBirthday()
        ageLabel.text = employeeDetailsPresenter.ageDescription()
        
        if let url = URL(string: employee.avatarUrl) {
            avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "goose"))
        }
    }
    
    @objc private func callButtonTapped() {
        employeeDetailsPresenter.makeCall()
    }
    
    private func configureNavigationBar() {
        let backButtonImage = UIImage(named: "arrow")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
