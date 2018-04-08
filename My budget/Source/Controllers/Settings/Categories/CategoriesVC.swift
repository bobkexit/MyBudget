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
    
     // MARK: - Properties
    
    var categoryType: CategoryType!
    var categories: Results<RealmCategory>!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        reloadData()
    }
    
    
    // MARK: - View Actions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let category = RealmCategory(name: "", categoryType: categoryType)
        DataManager.shared.createOrUpdate(data: category)
        reloadData()
        
        guard let visibleCells = tableView.visibleCells as? [CategoryCell] else {
            fatalError("Can't get visible category cells")
        }
        
        let cell = visibleCells.first(where: {$0.category.categoryId == category.categoryId })
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
        let data = DataManager.shared.getData(of: RealmCategory.self).filter("categoryTypeId = \(self.categoryType.rawValue)")//.sorted(byKeyPath: "name")
        
        self.categories = data
        self.tableView.reloadData()
    }
    
    override func getData(atIndexPath indexPath: IndexPath) -> Object? {
        return categories[indexPath.row]
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
        
        let category = categories[indexPath.row]
        cell.delegate = self
        cell.configureCell(category)
        
        return cell
    }
}


// MARK: UITableViewCellDelgate Methods

extension CategoriesVC: UITableViewCellDelgate {
    func cellDidEndEditing(editingCell: UITableViewCell) {
        
        guard let editingCell = editingCell as? CategoryCell else {
            fatalError("Cant cast cell to \(AccountCell.self)")
        }
        
        guard let indexPath = tableView.indexPath(for: editingCell) else { return }
        
        if let categoryName = editingCell.categoryName.text, !categoryName.isEmpty {
            
            let categoryId = categories[indexPath.row].categoryId
            let categoryName = categoryName.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
            let updatedCategory = RealmCategory(name: categoryName, categoryType: categoryType, categoryId: categoryId)
            
            DataManager.shared.createOrUpdate(data: updatedCategory)
        } else {
            DataManager.shared.remove(data: categories[indexPath.row])
        }
        self.reloadData()
    }
}
