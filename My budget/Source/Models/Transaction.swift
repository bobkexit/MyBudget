//
//  RealmTransaction.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class Transaction: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var account: Account?
    @objc dynamic var category: Category?
    @objc dynamic var amount: Float = 0.0
    @objc dynamic var comment: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
