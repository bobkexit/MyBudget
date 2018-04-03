//
//  CategoryType.swift
//  My budget
//
//  Created by Николай Маторин on 25.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

enum CategoryType: Int, EnumCollection {
    case debit = 1
    case credit = 2
    
    var sign: Int {
        switch self {
        case .debit:
            return 1
        case .credit:
            return -1
        }
    }
}
