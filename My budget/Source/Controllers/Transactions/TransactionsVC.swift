//
//  TransactionsVC.swift
//  My budget
//
//  Created by Николай Маторин on 16.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import RealmSwift

class TransactionsVC: BaseTableVC {
    
    // MARK: - Properties
    
    fileprivate var transactions: Results<RealmTransaction>!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .transaction, object: nil)
        
        reloadData()
    }
    
    
    // MARK: - View Actions
    @IBAction func addBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.toTransactionDetailVC, sender: self)
    }
    
    
    // MARK: - View Methods
    @objc func reloadData() {
        transactions = DataManager.shared.getData(of: RealmTransaction.self)
        tableView.reloadData()
    }
}


// MARK: UITableViewDelegate and UITableViewDataSource Methods

extension TransactionsVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.transactionCell) as? TransactionCell else {
            return UITableViewCell()
        }
        let transaction = transactions[indexPath.row]
        cell.configure(data: transaction)
        
        return cell
    }
    
    // MARK: - needs to refactoring (DRY)
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (row, indexPath) in
            let data = self.transactions[indexPath.row]
            DataManager.shared.remove(data: data)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = Constants.Colors.delete
        
        return [deleteAction]
    }
}

