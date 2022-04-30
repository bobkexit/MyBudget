//
//  Settings.swift
//  My budget
//
//  Created by Николай Маторин on 25.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

enum SettingsMenu: String, CustomStringConvertible, CaseIterable {
    case accounts
    case incomings
    case expenses
    case defaults
    
    var description: String {
        switch self {
        case .accounts:
            return Localization.accounts
        case .incomings:
            return Localization.incomings
        case .expenses:
            return Localization.expenses
        case .defaults:
            return Localization.defaults
        }
    }
}
