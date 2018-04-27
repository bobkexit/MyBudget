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
    
    var accountVM: AccountBalanceVM!
    
    override func configureCell(viewModel: SomeViewModel) {
       
        guard let viewModel = viewModel as? AccountBalanceVM else {
            fatalError("Cant cast SomeViewModel to AccountBalanceVM")
        }
        
        self.accountVM = viewModel
        self.accountImg.image = accountVM.accountType.image
        self.accountTitleLbl.text = accountVM.title
        self.accountBalanceLbl.text = accountVM.balanceWithCurrency
        self.accountBalanceLbl.textColor = accountVM.textColor
    }
   
}
