//
//  Account.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

struct Account: Entity {
    let name: String
    let currency: Currency
    let type: TypeAccount
}

extension Account {
    enum TypeAccount: Int {
        case paymentCard = 1
        case cash = 2
        case web = 3
    
    }
}
