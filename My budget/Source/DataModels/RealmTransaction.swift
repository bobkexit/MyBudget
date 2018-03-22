//
//  RealmTransaction.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTransaction: Object {
    @objc dynamic var transactionId = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var account: RealmAccount?
    @objc dynamic var category: RealmCategory?
    @objc dynamic var sum: Double = 0.0
    @objc dynamic var comment: String?
    
    override static func primaryKey() -> String? {
        return "transactionId"
    }
}
