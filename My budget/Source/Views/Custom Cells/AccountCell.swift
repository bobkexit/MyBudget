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
    
    var viewModel: AccountViewModel!
    
    @IBOutlet weak var accountTypeImg: UIImageView!
    @IBOutlet weak var accountNameTxt: UITextField!
    @IBOutlet weak var accountCurrencyLbl: UILabel!
    
    func configureCell() {
        accountNameTxt.delegate = self
        
        accountNameTxt.text = viewModel.title
        accountCurrencyLbl.text = viewModel.currencySymbol
        accountTypeImg.image = viewModel.accountType.image
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
