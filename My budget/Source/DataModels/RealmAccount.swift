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
    @objc dynamic var accountTypeId = 0
    @objc dynamic var currency: RealmCurrency?
    
    
    override static func primaryKey() -> String? {
        return "accountId"
    }
    
    convenience init(name: String, accountType: AccountType, currency: RealmCurrency) {
        self.init()
        self.name = name
        self.accountTypeId = accountType.rawValue
        self.currency = currency
    }
    
    convenience init(name: String, accountTypeId: Int, currency: RealmCurrency, accountId: String?) {
        self.init()
        self.name = name
        self.accountTypeId = accountTypeId
        self.currency = currency
        
        if let accountId = accountId {
            self.accountId = accountId
        }
    }
}
