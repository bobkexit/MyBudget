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

    // MARK: - IBOutlets
    
    @IBOutlet weak var accountTypeImage: UIImageView!
    @IBOutlet weak var accountNameTxt: UITextField!
    
    
    // MARK: - Properties
    
    fileprivate var accounts = DataManager.shared.getData(of: RealmAccount.self)
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Accounts"
        reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .account, object: nil)
    }

    
    // MARK: - View Actions
    
    @IBAction func addButtomPressed(_ sender: Any) {
        let addAccountVC = AddAccountVC()
        addAccountVC.modalPresentationStyle = .custom
        present(addAccountVC, animated: true, completion: nil)
    }
    
    
    // MARK: - View Methods
    
    @objc fileprivate func reloadData() {
        accounts = DataManager.shared.getData(of: RealmAccount.self)
        tableView.reloadData()
    }
    
    override func getData(atIndexPath indexPath: IndexPath) -> Object? {
        return accounts[indexPath.row]
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
        
        let account = accounts[indexPath.row]
        cell.delegate = self
        cell.configureCell(account: account, balance: nil)
        
        return cell
    }
}

// MARK: - UITableViewCellDelgate Methods

extension AccountsVC: UITableViewCellDelgate {
    func cellDidEndEditing(editingCell: UITableViewCell) {
        guard let editingCell = editingCell as? AccountCell else {
            fatalError("Cant cast cell to \(AccountCell.self)")
        }
        
        guard let indexPath = tableView.indexPath(for: editingCell) else { return }
        
        let account = accounts[indexPath.row]
        
        if let accountName = editingCell.accountNameTxt.text, !accountName.isEmpty {
            
            let accountName = accountName.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
            let updatedItem = RealmAccount(name: accountName, accountTypeId: account.accountTypeId, currencyCode: account.currencyCode!, accountId: account.accountId)
            
            DataManager.shared.createOrUpdate(data: updatedItem)
        } else {
            DataManager.shared.remove(data: account)
        }
        reloadData()
    }
}
