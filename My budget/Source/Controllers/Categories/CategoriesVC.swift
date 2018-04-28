//
//  IncomingAndExpensesVC.swift
//  My budget
//
//  Created by Николай Маторин on 20.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class CategoriesVC: BaseTableVC {
        
     // MARK: - Properties
    
    var dataManager: BaseDataManager<Category>?
    
    var viewModelFactory = ViewModelFactory.shared
    
    var categoryType: CategoryType!
    
    var categories = [SomeViewModel]()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        reloadData()
    }
    
    
    // MARK: - View Actions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        guard let dataManager = dataManager else {
            fatalError("Can't get propper data manager")
        }
        
        let category = dataManager.create()
        let viewModel = viewModelFactory.create(object: category, dataManager: dataManager)
        viewModel.save()
        
        reloadData()
        
        guard let visibleCells = tableView.visibleCells as? [CategoryCell] else {
            fatalError("Can't get visible category cells")
        }
        
        let cell = visibleCells.first(where: {$0.categoryViewModel?.id == viewModel.id })
        cell?.categoryName.becomeFirstResponder()
    }
    
    // MARK: - View Methods
    
    fileprivate func setTitle() {
        switch categoryType {
        case .debit:
            title = SettingsMenu.incomings.description
        case .credit:
            title = SettingsMenu.expenses.description
        default:
            return
        }
    }
    
    fileprivate func reloadData() {
    
        if self.categoryType == .credit {
            dataManager = ExpenseCategoryManager()
        } else if self.categoryType == .debit {
            dataManager = IncomeCategoryManager()
        }
        
        if let dataManager = dataManager {
            
            var data = dataManager.createArray()
          
            data = dataManager.getObjects()
            
            categories = data.map { viewModelFactory.create(object: $0, dataManager: dataManager) }
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.categoryCell, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        
        let viewModel = categories[indexPath.row]
        cell.delegate = self
        cell.configureCell(viewModel: viewModel)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, actionsWhenRemoveRowAt indexPath: IndexPath) {
        let viewModel = categories[indexPath.row]
        viewModel.delete()
        categories.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

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
            tableView(tableView, actionsWhenRemoveRowAt: indexPath)
        } else {
            let viewModel = categories[indexPath.row]
            viewModel.set(title!, forKey: "title")
            viewModel.save()
        }
    }
}
