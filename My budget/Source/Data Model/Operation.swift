//
//  Operation.swift
//  My budget
//
//  Created by Николай Маторин on 23.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

enum Operation: CustomStringConvertible {
    case income
    case expense
    
    var description: String {
        switch self {
        case .expense:
            return Localization.expense
        case .income:
            return Localization.income
        }
    }
}
