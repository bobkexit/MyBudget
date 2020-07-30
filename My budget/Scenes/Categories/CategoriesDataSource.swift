//
//  CategoriesDataSource.swift
//  My budget
//
//  Created by Nikolay Matorin on 23.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class CategoriesDataSource: UITableViewDiffableDataSource<CategoriesDataSource.Section, CategoryDTO> {
    
    enum Section: Int, CaseIterable {
        case main = 0
        case new
    }
    
    struct Actions {
        var deleteCategory: ((_ category: CategoryDTO) -> Void)?
    }
    
    var actions: Actions = Actions()
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let item = itemIdentifier(for: indexPath) {
            actions.deleteCategory?(item)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
