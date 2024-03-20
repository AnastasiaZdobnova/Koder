//
//  FilterBottomSheetViewController.swift
//  Koder
//
//  Created by Анастасия Здобнова on 20.03.2024.
//

import Foundation
import SnapKit

protocol FilterBottomSheetViewControllerProtocol : UIViewController {
    var filterBottomSheetPresenter: FilterBottomSheetPresenterProtocol { get }
    var selectedSort: String { get set }
}

class FilterBottomSheetViewController: UIViewController, FilterBottomSheetViewControllerProtocol {
    
    weak var delegate: FilterBottomSheetDelegate?
    
    var selectedSort: String
    
    var filterBottomSheetPresenter: FilterBottomSheetPresenterProtocol
    
    private let sheetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "Сортировка"
        return label
    }()
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = false
        setupUI()
        setupTableView()
    }
    
    init(presenter: FilterBottomSheetPresenterProtocol, selectedSort: String) {
        self.filterBottomSheetPresenter = presenter
        self.selectedSort = selectedSort
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        view.addSubview(sheetLabel)
        
        sheetLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(SortingOptionCell.self, forCellReuseIdentifier: SortingOptionCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(sheetLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}
extension FilterBottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(filterBottomSheetPresenter.filterBottomSheetModel.sortOptions.count)
        return filterBottomSheetPresenter.filterBottomSheetModel.sortOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortingOptionCell.identifier, for: indexPath) as! SortingOptionCell
        let option = filterBottomSheetPresenter.filterBottomSheetModel.sortOptions[indexPath.row]
        let isSelected = option == selectedSort
        print("option\(option) isSelected\(isSelected)")
        cell.configure(with: option, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        let sortOption = filterBottomSheetPresenter.filterBottomSheetModel.sortOptions[indexPath.row]
        delegate?.didSelectSortOption(sortOption)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // Здесь установите желаемую высоту ячейки
    }
}
