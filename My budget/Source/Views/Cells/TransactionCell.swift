//
//  TransactionCell.swift
//  My budget
//
//  Created by Николай Маторин on 27.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionCell: BaseCell {
    
    @IBOutlet weak var accountImg: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    var viewModel: TransactionViewModel!
    
    func configure() {
        accountImg.image = viewModel.accountType?.image
        categoryLbl.text = viewModel.category
        amountLbl.text =  viewModel.amount 
        amountLbl.textColor = viewModel.credit ? Constants.Colors.credit : Constants.Colors.green
        dateLbl.text = viewModel.date
    }
}
