//
//  TransactionsVC.swift
//  My budget
//
//  Created by Николай Маторин on 16.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionsVC: BaseTableVC {
    
    //typealias Entity = Transaction
    
    //typealias ViewModel = TransactionVM
    
    // MARK: - Properties
    
    var dataManager = BaseDataManager<Transaction>()
    
    var viewModelFactory = ViewModelFactory.shared
    
    var dataManagerFactory = DataManagerFactory.shared
    
    let notificationCenter = NotificationCenter.default
    
    var transactions = [SomeViewModel]()
    
    //var selectedTransaction: TransactionVM?
    
    var selectedOperation: Operation?

    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notificationCenter.addObserver(self, selector: #selector(incomingNotification(_:)), name: .transaction, object: nil)
    }
    
    // MARK: - View Actions
    @IBAction func addBtnPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Select operation", message: nil, preferredStyle: .actionSheet)
        
        let createIncome = UIAlertAction(title: Operation.income.rawValue, style: .default) { (action) in
            self.selectedOperation = Operation.income
            self.performSegue(withIdentifier: Constants.Segues.toCreateTransaction, sender: self)
        }
        let createExpense = UIAlertAction(title: Operation.expense.rawValue, style: .default) { (action) in
            self.selectedOperation = Operation.expense
            self.performSegue(withIdentifier: Constants.Segues.toCreateTransaction, sender: self)
        }
        
        alertController.addAction(createIncome)
        alertController.addAction(createExpense)
        
        self.present(alertController, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alertController.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var categoryManager: BaseDataManager<Category>!
        let accountManager = BaseDataManager<Account>()
        
        
        if segue.identifier == Constants.Segues.toTransactionDetailVC {
            
            guard let destinationVC = segue.destination as? TransactionDetailVC else {
                return
            }
            
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let selectedTransactionVM = transactions[indexPath.row]
            
            categoryManager = createCategoryManager(forTransaction: selectedTransactionVM)
            
            destinationVC.configure(viewModel: selectedTransactionVM, categoryManager: categoryManager, accountManager: accountManager)
            
        } else if segue.identifier == Constants.Segues.toCreateTransaction {
            
            guard let destinationVC = segue.destination as? CreateTransactionVC else {
                return
            }
            
            let newTransactionVM = createViewModel()
            
            categoryManager = createCategoryManager(forTransaction: newTransactionVM)
            
             destinationVC.configure(viewModel: newTransactionVM, categoryManager: categoryManager, accountManager: accountManager)
        }
    }
    
    
    // MARK: - View Methods
    @objc func incomingNotification(_ notification: Notification) {
        
        if let id = notification.userInfo?["trnsactionId"] as? URL {
            reloadTransaction(trnasactionId: id)
        } else {
            reloadData()
        }
        
    }
    
    func reloadTransaction(trnasactionId: URL?) {
        
        guard let row = transactions.index(where: {($0 as! TransactionVM).id == trnasactionId}) else {
            fatalError("Can't find index of upadted transaction")
        }
        
        let indexPath = IndexPath(row: row, section: 0)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func reloadData() {
        let data = dataManager.getObjects()
        
        transactions = data.map { viewModelFactory.create(object: $0, dataManager: dataManager) }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, actionsWhenRemoveRowAt indexPath: IndexPath) {
        let viewModel = transactions[indexPath.row]
        viewModel.delete()
        transactions.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func createViewModel() -> SomeViewModel {
        
        let transaction = dataManager.create()
        transaction.date = Date()
        
        let viewModel = viewModelFactory.create(object: transaction, dataManager: dataManager)
        viewModel.isNew = true
        
        if let account = UserSettings.defaults.account {
            viewModel.set(account, forKey: "account")
        }
        
        if selectedOperation == .income {
            viewModel.operationType = .debit
        } else if selectedOperation == .expense {
            viewModel.operationType = .credit
        }
        
        let categoryType = viewModel.operationType
        
        if let category = UserSettings.defaults.defaultCategory(forCategoryType: categoryType) {
            viewModel.set(category, forKey: "category")
        }
        
        //viewModel.set(temp: true)
        
        return viewModel
    }
    
    func createCategoryManager(forTransaction transaction: SomeViewModel) -> BaseDataManager<Category> {
        
        guard let transaction = transaction as? TransactionVM else {
            fatalError("Cant cast SomeViewModel to TransactionViewModel")
        }
        
        var categoryManager: BaseDataManager<Category>!
      
        if transaction.categoryType == .debit {
            categoryManager = IncomeCategoryManager()
        } else if transaction.categoryType == .credit {
            categoryManager = ExpenseCategoryManager()
        }
        
        return categoryManager
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
        cell.configureCell(viewModel: transactionViewModel)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedTransaction = transactions[indexPath.row]
        performSegue(withIdentifier: Constants.Segues.toTransactionDetailVC, sender: self)
    }
}

