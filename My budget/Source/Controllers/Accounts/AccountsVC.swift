//
//  DictionaryVC.swift
//  My budget
//
//  Created by Николай Маторин on 19.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class AccountsVC: BaseTableVC {
   
    // MARK: - IBOutlets
    
    @IBOutlet weak var accountTypeImage: UIImageView!
    
    @IBOutlet weak var accountNameTxt: UITextField!
    
    // MARK: - Properties
    
    var viewModelFactory = ViewModelFactory.shared
    
    let dataManager = BaseDataManager<Account>()
    
    var accounts = [SomeViewModel]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("accounts", comment: "")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .account, object: nil)
        reloadData()
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
            let account = dataManager.create()
            let viewModel = viewModelFactory.create(object: account, dataManager: dataManager, isNew: true)
            destinationVC.viewModel = viewModel
        }
    }
    
    // MARK: - View Methods
    
    @objc fileprivate func reloadData() {
        let data = dataManager.getObjects()
        accounts = data.map{ viewModelFactory.create(object: $0, dataManager: dataManager) }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, actionsWhenRemoveRowAt indexPath: IndexPath) {
        let viewModel = accounts[indexPath.row]
        viewModel.delete()
        accounts.remove(at: indexPath.row)
        NotificationCenter.default.post(name: .transaction, object: nil)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
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
        cell.configureCell(viewModel: accountViewModel)
        
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
             tableView(tableView, actionsWhenRemoveRowAt: indexPath)
        } else
        {
            let viewModel = accounts[indexPath.row]
            viewModel.set(title, forKey: "title")
            //viewModel.set(title: title!)
        }
    }
}
