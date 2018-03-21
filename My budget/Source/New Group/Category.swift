//
//  Category.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

struct Category: Entity {
    let name: String
    let type: TypeCategory
}

extension Category {
    enum TypeCategory: Int {
        case income = 1
        case expense = 2
    }
}
