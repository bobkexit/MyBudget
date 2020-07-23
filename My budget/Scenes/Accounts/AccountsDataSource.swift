//
//  AccountsDataSource.swift
//  My budget
//
//  Created by Николай Маторин on 22.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class AccountsDataSource: UITableViewDiffableDataSource<AccountsDataSource.Section, AccountDTO> {
    
    enum Section: Int, CaseIterable {
        case main
    }
    
    struct Actions {
        var deleteAccount: ((_ Account: AccountDTO) -> Void)?
    }
    
    var actions: Actions = Actions()
    
    var accountsController: AccountsControllerProtocol?
    
    convenience init(tableView: UITableView,
                     cellReuseIdentifier: String,
                     accountsController: AccountsControllerProtocol?) {
         
        
        
        self.init(tableView: tableView) { tableView, indexPath, account in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
            var text = account.name
            
            if let currencyCode = account.currencyCode {
               text += " → \(currencyCode)"
            }
            
            cell.textLabel?.text  = text
        
            if let type = account.kind.description() {
                cell.detailTextLabel?.text = "type".localized() + ": \(type)" 
            }
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.textLabel?.textColor = .babyPowder
            cell.detailTextLabel?.textColor = .babyPowder60
            
            return cell }
        
        self.accountsController = accountsController
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let item = itemIdentifier(for: indexPath) {
            defaultRowAnimation = .fade
            actions.deleteAccount?(item)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension AccountsDataSource: UITableViewDelegate {
    
}
