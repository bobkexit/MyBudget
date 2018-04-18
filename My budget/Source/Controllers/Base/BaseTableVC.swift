//
//  BaseTableVC.swift
//  My budget
//
//  Created by Николай Маторин on 19.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import RealmSwift // remove

class BaseTableVC: UITableViewController {
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tabBarController?.tabBar.selectedItem?.title

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = getDeleteRowAction()
        return [deleteAction]
    }
    
    final func getDeleteRowAction() -> UITableViewRowAction {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (row, indexPath) in
            self.tablewView(self.tableView, actionsWhenRemoveRowAt: indexPath)
        }
        deleteAction.backgroundColor = Constants.DefaultColors.red
        
        return deleteAction
    }
    
    func tablewView(_ tableView: UITableView, actionsWhenRemoveRowAt indexPath: IndexPath) {
         self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
