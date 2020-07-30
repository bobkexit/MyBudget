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
