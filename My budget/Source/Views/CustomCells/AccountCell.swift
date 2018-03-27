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
    
    @IBOutlet weak var accountTypeImg: UIImageView!
    @IBOutlet weak var accountNameTxt: UITextField!
    @IBOutlet weak var accountCurrencyLbl: UILabel!
    
    func configureCell(account: RealmAccount, balance: Double? = nil) {
        accountNameTxt.delegate = self
        
        accountNameTxt.text = account.name
        accountCurrencyLbl.text = account.currency?.code
        accountTypeImg.image = account.accountType?.image
    }
}

// MARK: - UITextFieldDelegate methods
extension AccountCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // close the keyboard on Enter
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.cellDidBeginEditing(editingCell: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.cellDidEndEditing(editingCell: self)
    }
}
