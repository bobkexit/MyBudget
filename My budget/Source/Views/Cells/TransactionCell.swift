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
    
    var transactionViewModel: TransactionVM?
    
    override func configureCell(viewModel: SomeViewModel) {
        guard let viewModel = viewModel as? TransactionVM else { return }
        
        self.transactionViewModel = viewModel
        
        accountImg.image = viewModel.accountType?.image
        
        if let categoryName = viewModel.category {
              categoryLbl.text = Helper.shared.trancate(Phrase: categoryName)
        }
        
        amountLbl.text =  viewModel.currencyAmount
        amountLbl.textColor = viewModel.color
        dateLbl.text = viewModel.date
    }
}
