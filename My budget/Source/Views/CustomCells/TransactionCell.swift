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
        amountLbl.text = (data.sum < 0 ? "-" : "+") + String(format: "%.2f", data.sum)
        amountLbl.textColor = data.sum < 0 ? Constants.Colors.credit : Constants.Colors.debit
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateLbl.text = dateFormatter.string(from: data.date)
    }
}
