//
//  AccountBalanceVM.swift
//  My budget
//
//  Created by Николай Маторин on 27.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class AccountBalanceVM: AccountVM {
    
    private(set) lazy var balanceWithCurrency: String? = {
        
        if let balance = object.transactions?.value(forKeyPath: "@sum.amount") as? NSNumber {
            
            self.textColor = balance.floatValue < 0 ? Constants.DefaultColors.red : Constants.DefaultColors.green
            
            return currencyFormatter.string(from: balance)
            
        }
        
        return nil
    }()
    
    private(set) var textColor: UIColor?
}
