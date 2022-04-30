//
//  DataModel.swift
//  My budget
//
//  Created by Николай Маторин on 21.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

enum CategoryType: Int, CaseIterable {
    case debit = 1
    case credit = 2
}

extension CategoryType {
    var title: String {
        switch self {
        case .debit: return Localization.income
        case .credit: return Localization.expense
        }
    }
}
