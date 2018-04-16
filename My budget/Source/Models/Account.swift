//
//  RealmAccount.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var typeId = 0
    //@objc dynamic var currencyCode: String? = Locale.current.currencyCode
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


