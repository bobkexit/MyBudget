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
    
    var transactionViewModel: TransactionVM!
    
    override func configureCell(viewModel: SomeViewModel) {
      
        guard let viewModel = viewModel as? TransactionVM else {
            fatalError("Cant cast SomeViewModel to CategoryViewModel")
        }
        
        self.transactionViewModel = viewModel
        
        accountImg.image = transactionViewModel.accountType?.image
        categoryLbl.text = transactionViewModel.category
        amountLbl.text =  transactionViewModel.currencyAmount
        amountLbl.textColor = transactionViewModel.color
        dateLbl.text = transactionViewModel.date
    }
}
