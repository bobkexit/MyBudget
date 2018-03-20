//
//  SettingsVC.swift
//  My budget
//
//  Created by Николай Маторин on 16.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class SettingsVC: BaseTableVC {
        
    fileprivate var settings = Array(AppDictionary.cases())
    fileprivate var selectedSetting: AppDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.register(SettingsCell.self, forCellReuseIdentifier: Constants.UI.TableViewCells.settingsCell)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.TableViewCells.settingsCell, for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: settings[indexPath.row].rawValue)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedSetting = settings[indexPath.row]
       
        switch selectedSetting! {
        case .accounts:
            performSegue(withIdentifier: Constants.Segues.toAccountsVC, sender: self)
        case .expenses, .incomings:
            performSegue(withIdentifier: Constants.Segues.toCategoriesVC, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedSetting = selectedSetting  else {
            return
        }
        
        switch selectedSetting {
        case .accounts:
            return
        case .incomings:
            set(categoryType: .income, to: segue)
        case .expenses:
            set(categoryType: .expense, to: segue)
        }
    }
    
    func set(categoryType type:  Category.TypeCategory, to segue: UIStoryboardSegue) {
        
        if segue.identifier != Constants.Segues.toCategoriesVC {
            return
        }
        
        guard let destinationVC = segue.destination as? CategoriesVC else {
            fatalError("Can't cast destinationVC to IncomingAndExpensesVC")
        }
        
        destinationVC.categoryType = type
    }
}
    

