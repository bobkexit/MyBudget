//
//  Operation.swift
//  My budget
//
//  Created by Николай Маторин on 23.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

enum Operation: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .expense:
            return NSLocalizedString("expense", comment: "")
        case .income:
            return NSLocalizedString("income", comment: "")
        }
    }
    
    case income
    case expense
}
