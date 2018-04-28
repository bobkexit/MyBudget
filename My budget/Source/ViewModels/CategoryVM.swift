//
//  CategoryViewModel.swift
//  My budget
//
//  Created by Николай Маторин on 11.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

class CategoryVM: BaseViewModel<Category> {
    
    // MARK: - Public Properties
    
    var id: String {
        let objectID = object.objectID
        let url = objectID.uriRepresentation()
        return url.absoluteString
    }
    
    var title: String? {
        return object.title
    }
    
    var categoryType: CategoryType  {
        let typeId = Int(self.object.typeId)
        guard let value = CategoryType(rawValue: typeId) else {
            fatalError("Incorrect category typeId")
        }
        return value
    }
    
    
    // MARK: - Setters

    override func set(_ value: Any?, forKey key: String) {
        
        var rawValue = value
        var rawKey = key
        
        if key.lowercased() == "categorytype", let categoryType = value as? CategoryType  {
            rawKey = "typeId"
            rawValue = Int16(categoryType.rawValue)
        }
        
        super.set(rawValue, forKey: rawKey)
    }
}
