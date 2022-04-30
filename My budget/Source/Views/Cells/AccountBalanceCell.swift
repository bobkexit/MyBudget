//
//  AccountBalanceCell.swift
//  My budget
//
//  Created by Николай Маторин on 27.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class AccountBalanceCell: BaseCell {

    @IBOutlet weak var accountImg: UIImageView!
    @IBOutlet weak var accountTitleLbl: UILabel!
    @IBOutlet weak var accountBalanceLbl: UILabel!
    
    var accountVM: AccountBalanceVM?
    
    override func configureCell(viewModel: SomeViewModel) {
        guard let viewModel = viewModel as? AccountBalanceVM else {
            return
        }
        
        self.accountVM = viewModel
        accountImg.image = viewModel.accountType?.image
        accountTitleLbl.text = viewModel.title
        accountBalanceLbl.text = viewModel.balanceWithCurrency
        accountBalanceLbl.textColor = viewModel.textColor
    }
}
