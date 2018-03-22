//
//  AppConstants.swift
//  My budget
//
//  Created by Николай Маторин on 19.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

struct Constants {
    struct UI {
        struct TableViewCells {
            static let settingsCell = "SettingsCell"
            static let accountCell = "AccountCell"
            static let categoryCell = "CategoryCell"
        }
    }
    
    struct Segues {
        static let toAccountsVC = "toAccountsVC"
        static let toCategoriesVC = "toCategoriesVC"
    }
    
    struct UserSettings {
        static let firstLaunch = "FIRST_LAUNCH"
    }
}

