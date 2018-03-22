//
//  RealmAccount.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmAccount: Object {
    
    @objc dynamic var accountId = UUID().uuidString
    @objc dynamic var name = ""
    @objc private dynamic var accountTypeId = 0
    @objc dynamic var currency: RealmCurrency?
    
    var accountType: AccountType {
        get {
            return AccountType(rawValue: accountTypeId)!
        }
        set {
            accountTypeId = newValue.rawValue
        }
    }
    
    override static func primaryKey() -> String? {
        return "accountId"
    }
    
}

extension RealmAccount {
    enum AccountType: Int {
        case paymentCard = 1
        case cash = 2
        case web = 3
    }
}
