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
        static let shoppingBasket =  #imageLiteral(resourceName: "Shopping Basket")
        static let trash = #imageLiteral(resourceName: "Trash")
        static let wallet = #imageLiteral(resourceName: "Wallet")
        static let web = #imageLiteral(resourceName: "Web")
        static let safe = #imageLiteral(resourceName: "Safe")
        static let creditCard = #imageLiteral(resourceName: "Credit Card")
    }
    
    struct Colors {
        static let delete = #colorLiteral(red: 0.9450980392, green: 0.3450980392, blue: 0.4078431373, alpha: 0.26171875)
        static let error = #colorLiteral(red: 0.9450980392, green: 0.3450980392, blue: 0.4078431373, alpha: 0.3020922517)
    }
    
    struct Identifiers {
        static let settingsCell = "SettingsCell"
        static let accountCell = "AccountCell"
        static let categoryCell = "CategoryCell"
    }
    
    struct Segues {
        static let toAccountsVC = "toAccountsVC"
        static let toCategoriesVC = "toCategoriesVC"
    }
    
    struct UserDefaults {
        static let firstLaunch = "FIRST_LAUNCH"
    }
}

