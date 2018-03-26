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

    @IBOutlet weak var accountTypeImage: UIImageView!
    
    @IBOutlet weak var accountNameTxt: UITextField!
    
    var accounts = DataManager.shared.getData(of: RealmAccount.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Accounts"
        reloadData()
    }

    @IBAction func addButtomPressed(_ sender: Any) {
        let addAccountVC = AddAccountVC()
        addAccountVC.delagate = self
        addAccountVC.modalPresentationStyle = .custom
        present(addAccountVC, animated: true, completion: nil)
    }
    
    func reloadData() {
        accounts = DataManager.shared.getData(of: RealmAccount.self)
        tableView.reloadData()
    }
    
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (row, indexPath) in
            let data = self.accounts[indexPath.row]
            DataManager.shared.remove(data: data)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = Constants.Colors.delete
        
        return [deleteAction]
    }
}

extension AccountsVC: AddAccountVCDelegate {
    func newAccountHasBeenCreated() {
        reloadData()
    }
}

extension AccountsVC: UITableViewCellDelgate {
    func cellDidBeginEditing(editingCell: UITableViewCell) {
        
    }
    
    func cellDidEndEditing(editingCell: UITableViewCell) {
        guard let editingCell = editingCell as? AccountCell else {
            fatalError("Cant cast cell to \(AccountCell.self)")
        }
        
        guard let indexPath = tableView.indexPath(for: editingCell) else { return }
        
        let account = accounts[indexPath.row]
        
        if let accountName = editingCell.accountNameTxt.text, !accountName.isEmpty {
            
            let accountName = accountName.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
            let updatedItem = RealmAccount(name: accountName, accountTypeId: account.accountTypeId, currency: account.currency!, accountId: account.accountId)
            
            DataManager.shared.createOrUpdate(data: updatedItem)
        } else {
            DataManager.shared.remove(data: account)
        }
        reloadData()
    }
    
   
}
