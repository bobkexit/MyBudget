//
//  IncomingAndExpensesVC.swift
//  My budget
//
//  Created by Николай Маторин on 20.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class CategoriesVC: BaseTableVC {
    
    var categoryType: RealmCategory.CategoryType!
    var repository = RealmRepository<RealmCategory>()
    var categories = [RealmCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    override func setup() {
        super.setup()
        setViewTitle()
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
        cell.configure(with: category.name)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Create", style: .default) { (action) in
            guard let name = textField.text, !name.isEmpty else {
                return
            }
            
            let category = RealmCategory(name: name, categoryType: self.categoryType)
           
            self.repository.insert(item: category, completion: { (error) in
                if let error = error {
                    print("Unable insert new catergory: \(error)")
                    return
                }
                self.reloadData()
            })
        }
        
        alert.addTextField { (alertTextField) in
            //alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.categories = self.repository.getAll().filter { $0.categoryType == self.categoryType }
            self.tableView.reloadData()
        }
    }    
}
