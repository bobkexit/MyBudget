//
//  AccountType.swift
//  My budget
//
//  Created by Николай Маторин on 21.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

enum AccountType: Int, CaseIterable, CustomStringConvertible {
    case cash = 1
    case paymentCard = 2
    case bankAccont = 3
    case web = 4
    
    var description: String {
        switch self {
        case .paymentCard:
            return Localization.paymentCard
        case .cash:
            return Localization.cash
        case .web:
            return Localization.web
        case .bankAccont:
            return Localization.bankAccont
        }
    }
    
    var image: UIImage? {
        switch self {
        case .paymentCard:
            return Constants.Images.creditCard
        case .cash:
            return Constants.Images.wallet
        case .web:
            return Constants.Images.web
        case .bankAccont:
            return Constants.Images.safe
        }
    }
}
