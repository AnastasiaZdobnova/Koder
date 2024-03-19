//
//  MainScreenViewController.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation
import UIKit
import SnapKit

protocol MainScreenViewControllerProtocol : UIViewController {
    var mainPresenter: MainScreenPresenterProtocol { get }
}

class MainScreenViewController: UIViewController, MainScreenViewControllerProtocol {
    
    var mainPresenter: MainScreenPresenterProtocol
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    init(presenter: MainScreenPresenterProtocol) {
        self.mainPresenter = presenter
        super.init(nibName: nil, bundle: nil)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DepartmentCell.self, forCellWithReuseIdentifier: "DepartmentCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalToSuperview()
            make.height.equalTo(36)
        }
    }
}

extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainPresenter.getDepartmentNames().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DepartmentCell", for: indexPath) as! DepartmentCell
        let departmentName = Array(mainPresenter.getDepartmentNames())[indexPath.row]
        cell.configure(with: departmentName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let departments = Array(mainPresenter.getDepartmentNames())
        print(departments)
        let departmentName = departments[indexPath.row]
        let textWidth = departmentName.width(withConstrainedHeight: 36, font: UIFont.systemFont(ofSize: 15))
        let cellWidth = textWidth + 24 // Допустим, добавляем 24 пункта для внутренних отступов
        print("id \(indexPath.row) Width \(cellWidth)")
        return CGSize(width: cellWidth, height: 36) // Задаем высоту ячейки
    }
}

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.width)
    }
}
