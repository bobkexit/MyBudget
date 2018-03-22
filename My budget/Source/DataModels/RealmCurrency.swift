//
//  RealmCurrency.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCurrency: Object {
    @objc dynamic var code = ""
    @objc dynamic var symbol = ""
    
    override class func primaryKey() -> String? {
        return "code"
    }
    
    convenience init(code: String, symbol: String) {
        self.init()
        self.code = code
        self.symbol = symbol
    }
}
