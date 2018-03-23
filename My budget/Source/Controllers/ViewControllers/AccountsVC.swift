//
//  DictionaryVC.swift
//  My budget
//
//  Created by Николай Маторин on 19.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class AccountsVC: BaseTableVC {

    let accountRepository = RealmRepository<RealmAccount>()
    var accounts = [RealmAccount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
    }

    @IBAction func addButtomPressed(_ sender: Any) {
        let addAccountVC = AddAccountVC()
        addAccountVC.delagate = self
        addAccountVC.modalPresentationStyle = .custom
        present(addAccountVC, animated: true, completion: nil)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.accounts = self.accountRepository.getAll()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.TableViewCells.accountCell, for: indexPath) as? AccountCell else {
            return UITableViewCell()
        }
        
        let account = accounts[indexPath.row]
        cell.configureCell(account: account, balance: nil)
        
        return cell
    }

}

extension AccountsVC: AddAccountVCDelegate {
    func newAccountHasBeenCreated() {
        reloadData()
    }
}
