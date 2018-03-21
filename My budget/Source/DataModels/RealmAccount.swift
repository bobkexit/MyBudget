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
    
    lazy var currencyRepository = RealmRepository<RealmCurrency>()
    
    @objc dynamic var name = ""
    @objc dynamic var typeId = 0
    @objc dynamic var currency: RealmCurrency?
    
    override static func ignoredProperties() -> [String] {
        return ["currencyRepository"]
    }
    
    convenience required init(entity: EntityType) {
        self.init()
        self.name = entity.name
        self.typeId = entity.type.rawValue
        
        guard let realmCurrency = currencyRepository.getRaw(byId: entity.currency.code) else {
            fatalError("Realm Error: account \(entity.currency.code) not found")
        }
        
        self.currency = realmCurrency
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
