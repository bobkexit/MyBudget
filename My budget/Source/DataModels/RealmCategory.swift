//
//  RealmCategory.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCategory: Object, RealmEntity {
    typealias EntityType = Category
    
    @objc dynamic var name = ""
    @objc dynamic var typeId = 0
    
    convenience required init(entity: EntityType) {
        self.init()
        
        self.name = entity.name
        self.typeId = entity.type.rawValue
        
    }

    var entity: Category {
        guard let type = Category.TypeCategory(rawValue: typeId) else {
            fatalError("Type category is not defined")
        }
        
        return Category(name: name, type: type)
    }
    
}


