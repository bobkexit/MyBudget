//
//  TransactionsVC.swift
//  My budget
//
//  Created by Николай Маторин on 16.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionsVC: BaseTableVC {
    
    typealias Entity = Transaction
    
    typealias ViewModel = TransactionVM
    
    // MARK: - Properties
    
    var dataManager = BaseDataManager<Transaction>()
    
    var viewModelFactory = ViewModelFactory.shared
    
    var transactions = [TransactionVM]()
    
    var selectedTransaction: TransactionVM?
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .transaction, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
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
            
            var viewModel: ViewModel
            
            if selectedTransaction != nil {
                viewModel = selectedTransaction!
            } else {
                let transaction = dataManager.create()
                viewModel = viewModelFactory.create(object: transaction, dataManager: dataManager)
            }
            
            destinationVC.viewModel = viewModel
        }
    }
    
    
    // MARK: - View Methods
    @objc func reloadData() {
        let data = dataManager.getObjects()
        transactions = data.map { viewModelFactory.create(object: $0, dataManager: dataManager) }
        tableView.reloadData()
    }
    
    override func tablewView(_ tableView: UITableView, actionsWhenRemoveRowAt indexPath: IndexPath) {
        let viewModel = transactions[indexPath.row]
        viewModel.delete()
        transactions.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}


// MARK: UITableViewDelegate and UITableViewDataSource Methods

extension TransactionsVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.transactionCell) as? TransactionCell else {
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

