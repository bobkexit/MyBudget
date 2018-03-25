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
    
    var categoryType: RealmCategory.CategoryType!
    var categories: Results<RealmCategory>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DataManager.shared.removeAllData(of: RealmCategory.self)
        setViewTitle()
        reloadData()
    }
    
    func setViewTitle() {
        switch categoryType {
        case .expense:
            title = AppDictionary.expenses.rawValue.capitalized
        case .income:
            title = AppDictionary.incomings.rawValue.capitalized
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.TableViewCells.categoryCell, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        
        let category = categories[indexPath.row]
        cell.delegate = self
        cell.configureCell(category)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let newCategory =   RealmCategory(name: "", categoryType: categoryType)
        DataManager.shared.createOrUpdate(data: newCategory)
        reloadData()
        
        guard let visibleCells = tableView.visibleCells as? [CategoryCell] else {
            fatalError("Can't get visible category cells")
        }
        
        let cell = visibleCells.first(where: {$0.category.categoryId == newCategory.categoryId })
        cell?.categoryName.becomeFirstResponder()
    }
    
    func reloadData() {
        let data = DataManager.shared.getData(of: RealmCategory.self).filter("categoryTypeId = \(self.categoryType.rawValue)")//.sorted(byKeyPath: "name")
        
        self.categories = data
        self.tableView.reloadData()
    }
}

extension CategoriesVC: UITableViewCellDelgate {
    func cellDidBeginEditing(editingCell: CategoryCell) {
        
    }
    
    func cellDidEndEditing(editingCell: CategoryCell) {
        
        guard let indexPath = tableView.indexPath(for: editingCell) else { return }
        
        if let categoryName = editingCell.categoryName.text, !categoryName.isEmpty {
            
            let updatedCategory = RealmCategory()
            updatedCategory.categoryId = categories[indexPath.row].categoryId
            updatedCategory.name = categoryName.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedCategory.categoryType = categoryType
            
            DataManager.shared.createOrUpdate(data: updatedCategory)
        } else {
            DataManager.shared.remove(data: categories[indexPath.row])
        }
        self.reloadData()
    }
}
