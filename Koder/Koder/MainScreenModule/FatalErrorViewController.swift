//
//  FatalErrorViewController.swift
//  Koder
//
//  Created by Анастасия Здобнова on 21.03.2024.
//

import Foundation
import SnapKit

class FatalErrorViewController: UIViewController {
    
    private let imageUFO: UIImageView = {
        let image = UIImageView(image: UIImage(named: "ufo"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Какой-то сверхразум все сломал"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Постараемся быстро починить"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let afreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("Попробовать снова", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(afreshButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(afreshButton)
        view.addSubview(imageUFO)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        afreshButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(12)
        }
        
        imageUFO.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).inset(8)
            make.width.equalTo(56)
        }
    }
    
    
    @objc private func afreshButtonTapped() {
        print("Filter button tapped")
        navigationController?.popToRootViewController(animated: true)
    }
}
