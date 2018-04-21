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
    
    let settings = Array(SettingsMenu.cases())
    
    var selectedSetting: SettingsMenu?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.settingsCell, for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        
        cell.configure(settings[indexPath.row].rawValue)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedSetting = settings[indexPath.row]
        
        switch selectedSetting! {
        case .accounts:
            performSegue(withIdentifier: Constants.Segues.toAccountsVC, sender: self)
        case .expenses, .incomings:
            performSegue(withIdentifier: Constants.Segues.toCategoriesVC, sender: self)
        case .defaults:
            performSegue(withIdentifier: Constants.Segues.toDefaultsVC, sender: self)
        }
    }
    
    // MARK: Passing Data Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.toCategoriesVC {
            
            guard let destinationVC = segue.destination as? CategoriesVC else {
                fatalError("Can't cast destinationVC to \(CategoriesVC.self)")
            }
            
            if selectedSetting == .incomings {
                
                destinationVC.categoryType = .debit
                
            } else if selectedSetting == .expenses {
                
                destinationVC.categoryType = .credit
                
            }
        }
    }
}
    

