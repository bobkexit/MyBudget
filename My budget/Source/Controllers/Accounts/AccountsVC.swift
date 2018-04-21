//
//  DictionaryVC.swift
//  My budget
//
//  Created by Николай Маторин on 19.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class AccountsVC: BaseTableVC {

    // MARK: - Type Alias
    
    typealias Entity = Account
    
    typealias ViewModel = AccountVM
   
    // MARK: - IBOutlets
    
    @IBOutlet weak var accountTypeImage: UIImageView!
    
    @IBOutlet weak var accountNameTxt: UITextField!
    
    // MARK: - Properties
    
    var viewModelFactory = ViewModelFactory.shared
    
    let dataManager = BaseDataManager<Account>()
    
    var accounts = [ViewModel]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Accounts"
        reloadData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        subscribe()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        unSubscribe()
//    }

    
    // MARK: - View Actions
    
    @IBAction func addBtnPressed(_ sender: Any) {
       performSegue(withIdentifier: Constants.Segues.toCreateAccountVC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.toCreateAccountVC {
            guard let destinationVC = segue.destination as? CreateAccountVC else {
                fatalError("Can't find CreateAccountVC")
            }
            let account = dataManager.create()
            let viewModel = viewModelFactory.create(object: account, dataManager: dataManager)
            destinationVC.viewModel = viewModel
        }
    }
    
    // MARK: - View Methods
    
    @objc fileprivate func reloadData() {
        let data = dataManager.getObjects()
        accounts = data.map{ viewModelFactory.create(object: $0, dataManager: dataManager) }
        tableView.reloadData()
    }
    
    override func tablewView(_ tableView: UITableView, actionsWhenRemoveRowAt indexPath: IndexPath) {
        let viewModel = accounts[indexPath.row]
        viewModel.delete()
        viewModel.save()
    }
    
//    func subscribe() {
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .account, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .accountHasBeenCreated, object: nil)
//    }
//
//    func unSubscribe() {
//        NotificationCenter.default.removeObserver(self, name: .account, object: nil)
//        NotificationCenter.default.removeObserver(self, name: .accountHasBeenCreated, object: nil)
//    }
}


// MARK: UITableViewDelegate and UITableViewDataSource Methods

extension AccountsVC {
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.accountCell, for: indexPath) as? AccountCell else {
            return UITableViewCell()
        }
        
        let accountViewModel = accounts[indexPath.row]
        cell.delegate = self
        cell.viewModel = accountViewModel
        cell.configureCell()
        
        return cell
    }
}

// MARK: - UITableViewCellDelgate Methods

extension AccountsVC: UITableViewCellDelgate {
    
    func cellDidEndEditing(editingCell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: editingCell) else {
            return
        }
        
        guard let editingCell = editingCell as? AccountCell  else {
            return
        }
        
        let title = editingCell.accountNameTxt.text
        
        if title?.isEmpty ?? true {
             tablewView(tableView, actionsWhenRemoveRowAt: indexPath)
        } else
        {
            let viewModel = accounts[indexPath.row]
            viewModel.set(title: title!)
        }
    }
}
