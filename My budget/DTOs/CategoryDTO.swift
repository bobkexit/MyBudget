//
//  CategoryDTO.swift
//  My budget
//
//  Created by Николай Маторин on 17.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation

struct CategoryDTO: Hashable {
    let id: String
    let name: String
    let kind: CategoryKind
}

extension CategoryDTO {
    func copy(name: String? = nil, kind: CategoryKind? = nil) -> CategoryDTO {
        return CategoryDTO(id: id, name: name ?? self.name, kind: kind ?? self.kind)
    }
    
    init(category: CategoryObject) {
        self.id = category.id
        self.name = category.name
        self.kind = CategoryKind(rawValue: category.kind)!
    }
}
