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
    
    typealias Entity = Transaction
    typealias ViewModel = TransactionViewModel
    
    // MARK: - Properties
    var dataManager = DataManager.shared
    var viewModelFactory: ViewModelFactoryProtocol = ViewModelFactory.shared
    
    fileprivate var transactions = [TransactionViewModel]()
    var selectedTransaction: TransactionViewModel?
    
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == Constants.Segues.toTransactionDetailVC {
            guard let destinationVC = segue.destination as? TransactionDetailVC else {
                return
            }
            let viewModel = selectedTransaction ?? viewModelFactory.createTransactionViewModel(model: nil)
            destinationVC.viewModel = viewModel
        }
    }
    
    
    // MARK: - View Methods
    @objc func reloadData() {
        let rawData = dataManager.fetchObjects(ofType: Transaction.self)
        transactions = rawData.map { viewModelFactory.createTransactionViewModel(model: $0) }
        tableView.reloadData()
    }
    
    override func tablewView(_ tableView: UITableView, actionsWhenRemoveRowAt indexPath: IndexPath) {
        let viewModel = transactions[indexPath.row]
        viewModel.remove { (error) in
            if error != nil { return }
            self.transactions.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
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
        let transactionViewModel = transactions[indexPath.row]
        cell.viewModel = transactionViewModel
        cell.configure()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTransaction = transactions[indexPath.row]
        performSegue(withIdentifier: Constants.Segues.toTransactionDetailVC, sender: self)
    }
}

