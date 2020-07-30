//
//  CategoriesViewController.swift
//  My budget
//
//  Created by Nikolay Matorin on 23.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

protocol CategoriesViewControllerDelegate: AnyObject {
    func categoriesViewController(_ viewController: CategoriesViewController, didSelectCategory category: CategoryDTO)
}

class CategoriesViewController: UIViewController {
    
    struct Actions {
        var createOperation: (() -> Void)?
    }
    
    enum CellIdentifier: String {
        case baseCell
        case editableCell
    }
    
    var actions: Actions = Actions()
    
    var canEditRow: Bool = true
    
    weak var delegate: CategoriesViewControllerDelegate?
    
    private var categoryName: String?
    
    private var selectedCategory: CategoryDTO?
    
    private var categoriesController: CategoriesControllerProtocol?

    private lazy var dataSource: UITableViewDiffableDataSource<CategoriesDataSource.Section, CategoryDTO> = makeDataSource()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.baseCell.rawValue)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: CellIdentifier.editableCell.rawValue)
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
        button.backgroundColor = .actionColor
        button.tintColor = .primaryBackgroundColor
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
    
    convenience init(categoriesController: CategoriesControllerProtocol, selectedCategory: CategoryDTO? = nil) {
        self.init()
        self.categoriesController = categoriesController
        self.selectedCategory = selectedCategory
    }
    
    deinit {
        print(self, #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNavigationBar()
        configureSearchController()
        setupObservers()
        
        tableView.dataSource = dataSource
        tableView.delegate = self
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tap.cancelsTouchesInView = false
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
        navigationItem.rightBarButtonItem?.tintColor = .primaryTextColor
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "search category".localizeCapitalizingFirstLetter()
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureViews() {
        view.backgroundColor = .primaryBackgroundColor
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
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardHeight = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight.cgRectValue.size.height, right: 0)
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

private extension CategoriesViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<CategoriesDataSource.Section, CategoryDTO> {
        let dataSource = CategoriesDataSource(tableView: tableView) { [weak self, selectedCategory] tableView, indexPath, category in
            
            guard let self = self else { return nil }
            
            let isEditableCell = indexPath.section == CategoriesDataSource.Section.new.rawValue || self.canEditRow
            
            if isEditableCell,
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.editableCell.rawValue,
                                                         for: indexPath) as? TextFieldCell {
                
                cell.textField.text = category.name
                cell.textField.textColor = .primaryTextColor
                cell.textField.tintColor = .actionColor
                cell.textField.backgroundColor = .clear
                cell.backgroundColor = .clear
                cell.delegate = self
                cell.setSelectionColor()
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.baseCell.rawValue,
                                                     for: indexPath)
            cell.textLabel?.text = category.name
            cell.backgroundColor = .clear
            cell.setSelectionColor()
            
            if category == selectedCategory {
                cell.accessoryType = .checkmark
                cell.tintColor = .actionColor
            }
        
            return cell
        }
        
        dataSource.actions = CategoriesDataSource.Actions(deleteCategory: { [weak categoriesController] category in
            categoriesController?.delete(category)
        })
        
        return dataSource
    }
    
    func updateUI(animated: Bool) {
        guard let controller = categoriesController else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<CategoriesDataSource.Section, CategoryDTO>()
        let categories = controller.getCategories(filteredByName: categoryName)
        snapshot.appendSections([.main])
        snapshot.appendItems(categories, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func addNewCategory() {
        guard let controller = categoriesController else { return }
        
        var snapshot = dataSource.snapshot()
        guard !snapshot.sectionIdentifiers.contains(.new) else { return }
        
        let category = controller.createCategory(withName: "")
        snapshot.appendSections([.new])
        snapshot.appendItems([category], toSection: .new)
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

extension CategoriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        categoryName = searchBar.text
        updateUI(animated: true)
    }
}
 
extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let delegate = delegate, let category = dataSource.itemIdentifier(for: indexPath) {
            delegate.categoriesViewController(self, didSelectCategory: category)
        } else if let cell = tableView.cellForRow(at: indexPath) as? TextFieldCell {
            cell.textField.isUserInteractionEnabled = true
            cell.textField.becomeFirstResponder()
        }
    }
}
