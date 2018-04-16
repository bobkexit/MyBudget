//
//  DictionaryVC.swift
//  My budget
//
//  Created by Николай Маторин on 19.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import RealmSwift

class AccountsVC: BaseTableVC {

    typealias Entity = Account
    typealias ViewModel = AccountViewModel
    typealias AccountType = BaseViewModel.AccountType
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var accountTypeImage: UIImageView!
    
    @IBOutlet weak var accountNameTxt: UITextField!
    
    
    // MARK: - Properties
    var viewModelFactory: ViewModelFactoryProtocol = ViewModelFactory.shared
    
    let dataManager = DataManager.shared
    
    fileprivate var accounts = [ViewModel]()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Accounts"
        reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .account, object: nil)
    }

    
    // MARK: - View Actions
    
    @IBAction func addBtnPressed(_ sender: Any) {
       performSegue(withIdentifier: Constants.Segues.toCreateAccountVC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.toCreateAccountVC {
            guard let destinationVC = segue.destination as? CreateAccountVC else {
                fatalError("Can't find CreateAccountVC")
            }
            let viewModel = viewModelFactory.createAccountViewModel(model: nil)
            destinationVC.viewModel = viewModel
        }
    }
    
    // MARK: - View Methods
    
    @objc fileprivate func reloadData() {
        let rawData = dataManager.fetchObjects(ofType: Entity.self)
        accounts = rawData.map{viewModelFactory.createAccountViewModel(model: $0)}
        tableView.reloadData()
    }
    
    func removeAccount(viewModel: ViewModel) {
        guard let model = dataManager.findObject(ofType: Entity.self, byId: viewModel.id) else {
            return
        }
        dataManager.remove(model) { _ in }
    }
    
    override func tablewView(_ tableView: UITableView, actionsWhenRemoveRowAt indexPath: IndexPath) {
        let viewModel = accounts[indexPath.row]
        viewModel.remove { (error) in
            if error != nil { return }
            self.accounts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


// MARK: UITableViewDelegate and UITableViewDataSource Methods

extension AccountsVC {
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.accountCell, for: indexPath) as? AccountCell else {
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
