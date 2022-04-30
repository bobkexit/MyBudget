//
//  Settings.swift
//  My budget
//
//  Created by Николай Маторин on 25.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

enum SettingsMenu: String, EnumCollection, CustomStringConvertible, CaseIterable {
    
    var description: String {
        switch self {
        case .accounts:
            return NSLocalizedString("accounts", comment: "")
        case .incomings:
            return NSLocalizedString("incomings", comment: "")
        case .expenses:
            return NSLocalizedString("expenses", comment: "")
        case .defaults:
            return NSLocalizedString("defaults", comment: "")
        }
    }
    
    case accounts
    case incomings
    case expenses
    case defaults
}
