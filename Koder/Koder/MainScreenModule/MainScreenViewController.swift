//
//  MainScreenViewController.swift
//  Koder
//
//  Created by Анастасия Здобнова on 19.03.2024.
//

import Foundation
import UIKit
import SnapKit
import SkeletonView

protocol MainScreenViewControllerProtocol : UIViewController {
    var mainPresenter: MainScreenPresenterProtocol { get }
}

class MainScreenViewController: UIViewController, MainScreenViewControllerProtocol {
    
    var mainPresenter: MainScreenPresenterProtocol
    private var collectionView: UICollectionView!
    private var selectedCategory = "Все"
    private var selectedSort = "По алфавиту"
    private var selectSearch = ""
    private var tableView: UITableView!
    private var grayViewRightConstraint: Constraint?
    private var isDataLoaded = false
    
    private let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6 // Установка фона в серый цвет
        view.layer.cornerRadius = 16 // Установка радиуса углов
        view.clipsToBounds = true // Обрезка по границе радиуса углов
        return view
    }()
    
    private let findTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введи имя, тег..."
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textField.textColor = .black
        textField.backgroundColor = .clear
        return textField
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(named: "filter") {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.isHidden = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Отмена", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.purple, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var xButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(named: "x") {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private let notFindImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "notFind")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        mainPresenter.fetchEmployees()
        setupTableView()
        setupNavigationBar()
        findTextField.delegate = self
        
        view.addSubview(notFindImageView)
        notFindImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(176)
            make.left.right.equalToSuperview().inset(16)
        }
        tableView.isSkeletonable = true
        showSkeleton()
    }
    
    init(presenter: MainScreenPresenterProtocol) {
        self.mainPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationBar(){
        view.addSubview(grayView)
        view.addSubview(filterButton)
        view.addSubview(findTextField)
        view.addSubview(cancelButton)
        
        grayView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(6)
            make.left.equalToSuperview().inset(16)
            self.grayViewRightConstraint = make.right.equalToSuperview().inset(16).constraint
            make.height.equalTo(40)
        }
        
        filterButton.snp.makeConstraints { make in
            make.centerY.equalTo(grayView)
            make.right.equalToSuperview().inset(30)
        }
        
        findTextField.snp.makeConstraints { make in
            make.centerY.equalTo(grayView)
            make.height.equalTo(24)
            make.left.equalToSuperview().offset(28)
            make.width.equalTo(204)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(28)
            make.centerY.equalTo(grayView)
        }
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
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: "EmployeeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshEmployeeData), for: .valueChanged)
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func updateUI(with employees: [Employee]) {
        self.isDataLoaded = true
        self.tableView.reloadData()
        tableView.hideSkeleton()
        endRefreshing()
    }
    
    func endRefreshing(){
        tableView.refreshControl?.endRefreshing()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        filterButton.isHidden = true
        cancelButton.isHidden = false
        
        grayViewRightConstraint?.update(inset: 94)
        view.addSubview(xButton)
        xButton.isHidden = false
        
        xButton.snp.makeConstraints { make in
            make.centerY.equalTo(grayView)
            make.right.equalTo(grayView).inset(13)
        }
    }

    @objc private func xButtonTapped() {
        findTextField.text = ""
        selectSearch = ""
        tableView.reloadData()
    }
    
    @objc private func cancelButtonTapped() {
        findTextField.text = ""
        selectSearch = ""
        tableView.reloadData()
        findTextField.resignFirstResponder() // Скрывает клавиатуру
        filterButton.isHidden = false
        cancelButton.isHidden = true
        xButton.isHidden = true
        grayViewRightConstraint?.update(inset: 16)
    }
    
    @objc private func filterButtonTapped() {
        print("Filter button tapped")
        mainPresenter.showFilterBottomSheet(selectedSort: self.selectedSort)
    }
    
    @objc private func refreshEmployeeData() {
        showSkeleton()
        mainPresenter.fetchEmployees()
    }
    
    func showBottomSheet(_ bottomSheet: UIViewController) {
        self.present(bottomSheet, animated: true)
    }
    
    private func showSkeleton() {
        tableView.showAnimatedSkeleton()
    }
    
}

extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainPresenter.getDepartmentNames().count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DepartmentCell", for: indexPath) as! DepartmentCell
        let departmentName = indexPath.row == 0 ? "Все" : Array(mainPresenter.getDepartmentNames())[indexPath.row - 1]
        cell.configure(with: departmentName, isSelected: departmentName == selectedCategory)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let departmentName = indexPath.row == 0 ? "Все" : Array(mainPresenter.getDepartmentNames())[indexPath.row - 1]
        var textWidth = departmentName.width(withConstrainedHeight: 36, font: UIFont.systemFont(ofSize: 15))
        if(departmentName == selectedCategory){
            textWidth = departmentName.width(withConstrainedHeight: 36, font: UIFont.systemFont(ofSize: 15, weight: .semibold))
        }
        let cellWidth = textWidth + 24
        return CGSize(width: cellWidth, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let departmentName = indexPath.row == 0 ? "Все" : Array(mainPresenter.getDepartmentNames())[indexPath.row - 1]
        selectedCategory = departmentName
        print("selectedCategory - \(departmentName)")
        collectionView.reloadData()
        print("selected search : \(selectSearch)")
        tableView.reloadData()
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

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfEmployees = mainPresenter.numberOfEmployees(selectedCategory: selectedCategory, search: selectSearch)
        notFindImageView.isHidden = !(numberOfEmployees == 0 && isDataLoaded)
        return numberOfEmployees
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        let employee = mainPresenter.getEmployeesInCategory(atIndex: indexPath.row, category: selectedCategory, sort: selectedSort, search: selectSearch)
        cell.configure(with: employee)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employee = mainPresenter.getEmployeesInCategory(atIndex: indexPath.row, category: selectedCategory, sort: selectedSort, search: selectSearch)
        mainPresenter.showEmployeeDetailScreen(for: employee)
    }
}

protocol FilterBottomSheetDelegate: AnyObject {
    func didSelectSortOption(_ sortOption: String)
}

extension MainScreenViewController: FilterBottomSheetDelegate {
    func didSelectSortOption(_ sortOption: String) {
        selectedSort = sortOption
        tableView.reloadData()
    }
}

extension MainScreenViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text, let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            self.selectSearch = updatedText
            tableView.reloadData()
        }
        return true
    }
}

extension MainScreenViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1 // Количество секций для скелетона
    }

    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // Примерное количество строк скелетона
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "EmployeeTableViewCell" // Идентификатор вашей ячейки
    }
}
