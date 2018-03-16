//
//  RealmAccount.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmAccount: Object, RealmEntity {
    typealias EntityType = Account
    
    @objc dynamic var name = ""
    @objc dynamic var typeId = 0
    @objc dynamic var currency: RealmCurrency?
    
    convenience required init(entity: EntityType) {
        self.init()
        self.name = entity.name
        self.typeId = entity.type.rawValue
        self.currency = RealmCurrency(entity: entity.currency)
    }
    
    var entity: Account {
        guard let type = Account.TypeAccount(rawValue: typeId) else {
            fatalError("Type account not defined")
        }
        guard let currency = currency?.entity else {
            fatalError("Currency not defined")
        }
        
        return Account(name: name, currency: currency, type: type)
    }

}
