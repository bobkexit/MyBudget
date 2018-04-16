//
//  BaseViewModel.swift
//  My budget
//
//  Created by Николай Маторин on 11.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

struct BaseViewModel {
    enum CategoryType: Int, EnumCollection {
        case none = 0
        case debit = 1
        case credit = 2
    }
    
    enum AccountType: Int, EnumCollection, CustomStringConvertible {
        case cash = 1
        case paymentCard = 2
        case bankAccont = 3
        case web = 4
        
        var description: String {
            switch self {
            case .paymentCard:
                return "payment card"
            case .cash:
                return "cash"
            case .web:
                return "web"
            case .bankAccont:
                return "bank account"
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
}
