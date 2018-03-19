//
//  SettingsVC.swift
//  My budget
//
//  Created by Николай Маторин on 16.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class SettingsVC: BaseTableVC {
    
    //@IBOutlet weak var tableView: UITableView!
    
    var settings = ["Accounts", "Incoming", "Expenses"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.register(SettingsCell.self, forCellReuseIdentifier: Constants.UI.TableViewCells.settingsCell)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
        
        
    }
 
//    override func setupView() {
//        super.setupView()
//
//        self.tableView.backgroundColor = UIColor.clear
//        self.tableView.separatorStyle = .none
//    }

}

extension SettingsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.TableViewCells.settingsCell, for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
    
        cell.configure(with: settings[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segues.toDictionaryVC, sender: self)
    }
}
