//
//  RealmCurrency.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCurrency: Object, RealmEntity {
    typealias EntityType = Currency
    
    @objc dynamic var code = ""
    @objc dynamic var symbol = ""
    
    convenience required init(entity: EntityType) {
        self.init()
        self.code = entity.code
        self.symbol = entity.symbol
    }
    
    var entity: Currency {
        return Currency(code: code, symbol: symbol)
    }
}
