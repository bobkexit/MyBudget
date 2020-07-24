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
        case main
    }
    
    private var categoriesController: CategoriesControllerProtocol?
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let item = itemIdentifier(for: indexPath) {
            //defaultRowAnimation = .fade
            categoriesController?.delete(item)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
   
    convenience init(tableView: UITableView,
                     categoriesController: CategoriesControllerProtocol?,
                     cellProvider: @escaping UITableViewDiffableDataSource<Section, CategoryDTO>.CellProvider) {
        self.init(tableView: tableView, cellProvider: cellProvider)
        self.categoriesController = categoriesController
    }
}
