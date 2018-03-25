//
//  AccountCell.swift
//  My budget
//
//  Created by Николай Маторин on 20.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import RealmSwift

class AccountCell: BaseCell {
    
    @IBOutlet weak var accountTitle: UILabel!
    @IBOutlet weak var accountType: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    func configureCell(account: RealmAccount, balance: Double? = nil) {
       
        accountTitle.text = account.name
        accountType.text = account.accountType.description
        
        if let balance = balance {
            balanceLabel.text = "\(balance) \(account.currency?.symbol ?? ""))"
        } else {
            balanceLabel.text = ""
        }
    }
    
    override func setupView() {
        super.setupView()
        accessoryType = .none
    }
}
