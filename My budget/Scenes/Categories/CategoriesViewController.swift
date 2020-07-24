//
//  CategoriesViewController.swift
//  My budget
//
//  Created by Nikolay Matorin on 23.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    struct Actions {
        var createOperation: (() -> Void)?
    }
    
    var categoriesController: CategoriesControllerProtocol?
    
    var actions: Actions = Actions()
    
    private var newCategory: CategoryDTO?
    
    private let cellReuseIdentifier = "CategoryCell"
    
    private lazy var dataSource: UITableViewDiffableDataSource<CategoriesDataSource.Section, CategoryDTO> = makeDataSource()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero,
                                                         size: CGSize(width: 0, height: CGFloat.leastNormalMagnitude)))
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero,
                                                         size: CGSize(width: tableView.frame.size.width, height: 60.0)))
        return tableView
    } ()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.plus, for: .normal)
        button.backgroundColor = .orangePeel
        button.tintColor = .richBlackForga30
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        return button
    } ()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.layer.cornerRadius = addButton.bounds.height / 2
    }
    
    @objc private func addButtonTapped(_ sender: UIButton) {
        addNewCategory()
    }
    
    convenience init(categoriesController: CategoriesControllerProtocol) {
        self.init()
        self.categoriesController = categoriesController
    }
    
    var removeAnimated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNavigationBar()
        
        //tableView.delegate = self
        tableView.dataSource = dataSource
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tap)
        
        categoriesController?.handlers = CategoriesHandlers(
            didFetchCategories: { [weak self] in
                self?.updateUI(animated: false)
            }, didUpdateCategories: { [weak self] in
                self?.updateUI(animated: false)
            }, didDeleteCategories: { [weak self] in
                self?.updateUI(animated: true)
            }, didInsertCategories: { [weak self] in
                self?.updateUI(animated: false)
            }, didFail: nil)
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem?.tintColor = .babyPowder
        navigationItem.searchController = searchController
    }
    
    private func configureViews() {
        view.backgroundColor = .richBlackForga30
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 48.0),
            addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

private extension CategoriesViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<CategoriesDataSource.Section, CategoryDTO> {
        let reuseIdentifier = cellReuseIdentifier
        return CategoriesDataSource(tableView: tableView,
                                    categoriesController: categoriesController) { tableView, indexPath, category in
                                        
                                        guard let cell = tableView.dequeueReusableCell(
                                            withIdentifier: reuseIdentifier, for: indexPath) as? TextFieldCell else { return nil }
                                        
                                        cell.textField.text = category.name
                                        cell.textField.textColor = .babyPowder
                                        cell.textField.backgroundColor = .clear
                                        cell.backgroundColor = .clear
                                        cell.delegate = self
                                        cell.selectionStyle = .none
                                        
                                        return cell
        }
    }
    
    func updateUI(animated: Bool) {
        guard let controller = categoriesController else { return }
    
        var snapshot = NSDiffableDataSourceSnapshot<CategoriesDataSource.Section, CategoryDTO>()
        let categories = controller.getCategories()
        snapshot.appendSections([.main])
        snapshot.appendItems(categories, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func addNewCategory() {
        guard let controller = categoriesController else { return }
        
        var snapshot = dataSource.snapshot()
        
        let category = controller.createCategory(withName: "")
        snapshot.appendItems([category], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        if let indexPath = dataSource.indexPath(for: category),
            let cell = tableView.cellForRow(at: indexPath) as? TextFieldCell {
            cell.textField.becomeFirstResponder()
        }
        
    }
}

extension CategoriesViewController: TextFieldCellDelegate {
    func textFieldCell(_ cell: TextFieldCell, didEndEditingTextField textField: UITextField) {
        guard let indexPath = tableView.indexPath(for: cell),
            let categoryName = textField.text, !categoryName.isEmpty else {
                updateUI(animated: true)
                return
        }
        
        if let category = dataSource.itemIdentifier(for: indexPath),
            category.name != categoryName {
            let newCategory = category.copy(name: categoryName)
            categoriesController?.save(newCategory)
        }
    }
}
