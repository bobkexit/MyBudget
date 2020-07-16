//
//  BaseTableVC.swift
//  My budget
//
//  Created by Николай Маторин on 19.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

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
        let deleteAction = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete", comment: "")) { (row, indexPath) in
            self.tableView(self.tableView, actionsWhenRemoveRowAt: indexPath)
        }
        deleteAction.backgroundColor = Constants.DefaultColors.red
        
        return deleteAction
    }
    
    func tableView(_ tableView: UITableView, actionsWhenRemoveRowAt indexPath: IndexPath) {
        
    }
    
//    final func removeViewModel(fromTableView tableView: UITableView, andArry array: [SomeViewModel], atIndexPath indexPath: IndexPath, _ completion: ([SomeViewModel]) -> ()?) {
//        
//        //, _ completion: ([SomeViewModel]) -> ()?
//        var tempArray = array
//        
//        let viewModel = array[indexPath.row]
//        viewModel.delete()
//        tempArray.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//        
//        completion(tempArray)
//    }
}
