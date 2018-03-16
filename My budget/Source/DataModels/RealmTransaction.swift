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
    
    @objc dynamic var transactionId = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var account: RealmAccount?
    @objc dynamic var category: RealmCategory?
    @objc dynamic var sum: Double = 0.0
    @objc dynamic var comment: String?
    
    override static func primaryKey() -> String? {
        return "transactionId"
    }

    convenience required init(entity: EntityType) {
        self.init()
        
        self.date = entity.date
        self.account = RealmAccount(entity: entity.account)
        self.category = RealmCategory(entity: entity.category)
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
