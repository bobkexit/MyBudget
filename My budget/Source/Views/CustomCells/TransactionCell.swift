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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(data: RealmTransaction) {
        accountImg.image = data.account?.accountType?.image
        categoryLbl.text = data.category?.name
        
        // TODO: need to refactor
        if let currencyCode = data.account?.currencyCode {
            amountLbl.text = Helper.shared.formatCurrency(data.sum, currencyCode: currencyCode)
        }
        amountLbl.textColor = data.sum < 0 ? Constants.Colors.credit : Constants.Colors.debit
        
        let dateFormatter = Helper.shared.getDateFormatter()
        dateLbl.text = dateFormatter.string(from: data.date)
    }
}
