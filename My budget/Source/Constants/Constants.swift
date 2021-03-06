//
//  AppConstants.swift
//  My budget
//
//  Created by Николай Маторин on 19.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

struct Constants {
   
    struct Images {
        static let shoppingBasket = #imageLiteral(resourceName: "Shopping Basket")
        static let trash = #imageLiteral(resourceName: "Trash")
        static let wallet = #imageLiteral(resourceName: "Wallet")
        static let web = #imageLiteral(resourceName: "Web")
        static let safe = #imageLiteral(resourceName: "Safe")
        static let creditCard = #imageLiteral(resourceName: "Credit Card")
    }
    
    struct DefaultColors {
//        static let delete = #colorLiteral(red: 0.9450980392, green: 0.3450980392, blue: 0.4078431373, alpha: 0.26171875)
//        static let error = #colorLiteral(red: 0.9450980392, green: 0.3450980392, blue: 0.4078431373, alpha: 0.3020922517)
        static let green = #colorLiteral(red: 0.6196078431, green: 0.8, blue: 0.5411764706, alpha: 1)
        static let red = #colorLiteral(red: 0.9450980392, green: 0.3450980392, blue: 0.4078431373, alpha: 1)
        static let gradientBackground =  [#colorLiteral(red: 0.1215686275, green: 0.1568627451, blue: 0.1764705882, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.03137254902, blue: 0.03529411765, alpha: 1)]
    }
    
    struct CellIdentifiers {
        static let settingsCell = "SettingsCell"
        static let accountCell = "AccountCell"
        static let categoryCell = "CategoryCell"
        static let transactionCell = "TransactionCell"
        static let reportCell = "ReportCell"
        static let accountBalanceCell = "AccountBalanceCell"
    }
    
    struct Segues {
        static let toAccountsVC = "toAccountsVC"
        static let toCreateAccountVC = "toCreateAccountVC"
        static let toCategoriesVC = "toCategoriesVC"
        static let toTransactionDetailVC = "toTransactionDetailVC"
        static let toCreateTransaction = "toCreateTransaction"
        
        static let toQRScannerVC = "toQRScannerVC"
        static let toDefaultsVC = "toDefaultsVC"
        
        static let toExpensesReport = "toExpensesReport"
        static let toBalanceReport = "toBalanceReport"
    }
    
    struct UserSettings {
        struct Keys {
            static let firstLaunch = "FIRST_LAUNCH"
            static let defaultCurrencyCode = "DEFAULT_CURRENCY_CODE"
            static let defaultAccountId = "DEFAULT_ACCOUNT_ID"
            static let defaultExpenseCategoryId = "DEFAULT_EXPENSE_CATEGORY_ID"
            static let defaultIncomeCategoryId = "DEFAULT_INCOME_CATEGORY_ID"
        }
        
        struct BuildInData {
            static let initialBalanceId = "INIT_BALANCE_ID"
        }
    }
    
    struct Reports {
        static let countCategoriesToShow = 5
    }
}

