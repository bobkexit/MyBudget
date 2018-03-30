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
        reloadData()
    }
    
    
    // MARK: - View Actions
    @IBAction func addBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.toTransactionDetailVC, sender: self)
    }
    
    
    // MARK: - View Methods
    func reloadData() {
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
}

