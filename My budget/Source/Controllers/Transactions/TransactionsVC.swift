//
//  TransactionsVC.swift
//  My budget
//
//  Created by Николай Маторин on 16.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionsVC: BaseTableVC {
    
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
        
        let alertController = UIAlertController(
            title: Localization.selectOperation,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let createIncome = UIAlertAction(
            title: Operation.income.description,
            style: .default
        ) { [weak self] action in
            guard let strongSelf = self else { return }
            strongSelf.selectedOperation = Operation.income
            strongSelf.performSegue(withIdentifier: Constants.Segues.toCreateTransaction, sender: strongSelf)
        }
        
        let createExpense = UIAlertAction(
            title: Operation.expense.description,
            style: .default
        ) { [weak self] action in
            guard let strongSelf = self else { return }
            strongSelf.selectedOperation = Operation.expense
            strongSelf.performSegue(withIdentifier: Constants.Segues.toCreateTransaction, sender: strongSelf)
        }
        
        alertController.addAction(createIncome)
        alertController.addAction(createExpense)
        
        if let popoverPresentationController =  alertController.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.maxX, y: 0, width: 0, height: 0)
        }
        
        present(alertController, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alertController.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func dismissAlertController(){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let accountManager = BaseDataManager<Account>()
        
        if segue.identifier == Constants.Segues.toTransactionDetailVC {
            
            guard let destinationVC = segue.destination as? TransactionDetailVC else {
                return
            }
            
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let selectedTransactionVM = transactions[indexPath.row]
            
            if let categoryManager = createCategoryManager(forTransaction: selectedTransactionVM) {
                destinationVC.configure(
                    viewModel: selectedTransactionVM,
                    categoryManager: categoryManager,
                    accountManager: accountManager
                )
            }
        } else if segue.identifier == Constants.Segues.toCreateTransaction {
            
            guard
                let destinationVC = segue.destination as? CreateTransactionVC,
                let newTransactionVM = createViewModel()
            else { return }
            
            if let categoryManager = createCategoryManager(forTransaction: newTransactionVM) {
                destinationVC.configure(
                    viewModel: newTransactionVM,
                    categoryManager: categoryManager,
                    accountManager: accountManager
                )
            }
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
        guard let row = transactions.firstIndex(where: {($0 as? TransactionVM)?.id == trnasactionId}) else {
            return
        }
        
        let indexPath = IndexPath(row: row, section: 0)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func reloadData() {
        
        let data = dataManager.getObjects()
        
        let sortedData = data.sorted(by: {$0.date! > $1.date!})
        
        transactions = sortedData.map { viewModelFactory.create(object: $0, dataManager: dataManager) }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, actionsWhenRemoveRowAt indexPath: IndexPath) {
        let viewModel = transactions[indexPath.row]
        viewModel.delete()
        transactions.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func createViewModel() -> SomeViewModel? {
        
        guard let transaction = dataManager.create() else { return nil }
        
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
        
        return viewModel
    }
    
    func createCategoryManager(forTransaction transaction: SomeViewModel) -> BaseDataManager<Category>? {
        guard let transaction = transaction as? TransactionVM else {
           return nil
        }
        
        switch transaction.categoryType {
        case .debit: return IncomeCategoryManager()
        case .credit: return ExpenseCategoryManager()
        case .none: return nil
        }
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

