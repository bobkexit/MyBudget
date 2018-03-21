//
//  RealmTransaction.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTransaction: Object, RealmEntity {
    typealias EntityType = Transaction
    
    lazy var accountRepository = RealmRepository<RealmAccount>()
    lazy var categoryRepository = RealmRepository<RealmCategory>()
    
    @objc dynamic var transactionId = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var account: RealmAccount?
    @objc dynamic var category: RealmCategory?
    @objc dynamic var sum: Double = 0.0
    @objc dynamic var comment: String?
    
    override static func primaryKey() -> String? {
        return "transactionId"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["accountRepository", "categoryRepository"]
    }

    convenience required init(entity: EntityType) {
        self.init()
        
        self.date = entity.date
        
        guard let realmAccount = accountRepository.getRaw(byId: entity.account.name) else {
            fatalError("Realm Error: account \(entity.account.name) not found")
        }
        
        guard let realmCategory = categoryRepository.getRaw(byId: entity.category.name) else {
            fatalError("Realm Error: category \(entity.category.name) not found")
        }
        
        self.account = realmAccount
        self.category = realmCategory
        self.sum = entity.sum
        self.comment = entity.comment
        
        if let transactionId = entity.transactionId {
            self.transactionId = transactionId
        }
    }

    var entity: Transaction {
        
        guard let account = account?.entity else {
            fatalError("Account is not defined")
        }
        
        guard let category = category?.entity else {
             fatalError("Category is not defined")
        }
        
        return Transaction(transactionId: transactionId, date: date, account: account, category: category, sum: sum, comment: comment)
    }
    
}
