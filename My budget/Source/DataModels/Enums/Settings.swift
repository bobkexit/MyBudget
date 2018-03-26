//
//  Settings.swift
//  My budget
//
//  Created by Николай Маторин on 25.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

enum Settings: String, EnumCollection {
    case accounts
    case incomings
    case expenses
    
    func gwtrRelatedCategoryType() -> CategoryType? {
        switch self {
        case .expenses:
            return CategoryType.credit
        case .incomings:
            return CategoryType.debit
        default:
            return nil
        }
    }
}
