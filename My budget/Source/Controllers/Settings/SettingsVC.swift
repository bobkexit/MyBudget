//
//  SettingsVC.swift
//  My budget
//
//  Created by Николай Маторин on 16.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class SettingsVC: BaseTableVC {
    
    // MARK: - Properties
    
    fileprivate let settings = Array(Settings.cases())
    fileprivate var selectedSetting: Settings?
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
}


// MARK: UITableViewDelegate and UITableViewDataSource Methods

extension SettingsVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.settingsCell, for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        
        cell.configure(settings[indexPath.row].rawValue)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
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
        
        if selectedSetting == .incomings || selectedSetting == .expenses {
            guard let destinationVC = segue.destination as? CategoriesVC else {
                fatalError("Can't cast destinationVC to \(CategoriesVC.self)")
            }
            
            guard let categoryType = selectedSetting.gwtrRelatedCategoryType() else {
                fatalError("Can't get related category type for setting = \(selectedSetting.rawValue)")
            }
            
            destinationVC.categoryType = categoryType
        }
    }
}
    

