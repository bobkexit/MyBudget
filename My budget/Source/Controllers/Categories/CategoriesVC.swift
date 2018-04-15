//
//  IncomingAndExpensesVC.swift
//  My budget
//
//  Created by Николай Маторин on 20.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesVC: BaseTableVC {
    
    typealias Entity = Category
    typealias ViewModel = CategoryViewModel
    typealias CategoryType = BaseViewModel.CategoryType
    
     // MARK: - Properties
    var dataManager = DataManager.shared
    var viewModelFactory: ViewModelFactoryProtocol = ViewModelFactory.shared
    
    var categoryType: CategoryType!
    var categories = [CategoryViewModel]()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        reloadData()
    }
    
    
    // MARK: - View Actions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let viewModel = viewModelFactory.createCategoryViewModel(model: nil)
        viewModel.set(categoryType: categoryType)
        viewModel.save()
        reloadData()
        
        guard let visibleCells = tableView.visibleCells as? [CategoryCell] else {
            fatalError("Can't get visible category cells")
        }
        
        let cell = visibleCells.first(where: {$0.viewModel?.id == viewModel.id })
        cell?.categoryName.becomeFirstResponder()
    }
    
    // MARK: - View Methods
    
    fileprivate func setTitle() {
        switch categoryType {
        case .debit:
            title = Settings.incomings.rawValue.capitalized
        case .credit:
            title = Settings.expenses.rawValue.capitalized
        default:
            return
        }
    }
    
    fileprivate func reloadData() {
        var rawData = dataManager.fetchObjects(ofType: Entity.self)
        rawData = rawData.filter("typeId = \(self.categoryType.rawValue)")
        
        categories = rawData.map { viewModelFactory.createCategoryViewModel(model: $0) }
        
        self.tableView.reloadData()
    }
    
    fileprivate func deleteEmptyCategory(viewModel: ViewModel) {
        guard let model = dataManager.findObject(ofType: Entity.self, byId: viewModel.id) else {
            return
        }
        dataManager.remove(model) { _ in }
    }
    
    override func tablewView(_ tableView: UITableView, actionsWhenRemoveRowAt indexPath: IndexPath) {
        let viewModel = categories[indexPath.row]
        viewModel.remove { (error) in
            if error != nil { return }
            self.categories.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


// MARK: UITableViewDelegate and UITableViewDataSource Methods

extension CategoriesVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.categoryCell, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        
        let viewModel = categories[indexPath.row]
        cell.delegate = self
        cell.configureCell(viewModel: viewModel)
        
        return cell
    }
}


// MARK: UITableViewCellDelgate Methods

extension CategoriesVC: UITableViewCellDelgate {
    func cellDidEndEditing(editingCell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: editingCell) else {
            return
        }
        
        guard let editingCell = editingCell as? CategoryCell else {
            return
        }
    
        let title = editingCell.categoryName.text
        
        if title?.isEmpty ?? true {
            tablewView(tableView, actionsWhenRemoveRowAt: indexPath)
        } else {
            let viewModel = categories[indexPath.row]
            viewModel.set(title: title!)
        }
    }
}
