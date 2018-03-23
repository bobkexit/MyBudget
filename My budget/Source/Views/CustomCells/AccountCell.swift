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
    
    override func configureCell(_ data: Object) {
        guard let account = data as? RealmAccount else {
            return
        }
        
        accountTitle.text = account.name
        accountType.text = account.accountType.description
    }
    
    func configureCell(account: RealmAccount, balance: Double? = nil) {
        self.configureCell(account)
        
        if let balance = balance {
            balanceLabel.text = "\(balance) \(account.currency?.symbol ?? ""))"
        } else {
            balanceLabel.text = ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func setup() {
        super.setup()
        accessoryType = .none
    }
}
