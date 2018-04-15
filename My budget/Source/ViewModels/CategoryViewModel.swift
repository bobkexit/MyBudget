//
//  CategoryViewModel.swift
//  My budget
//
//  Created by Николай Маторин on 11.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

struct CategoryViewModel {
    typealias Entity = Category
    typealias CategoryType = BaseViewModel.CategoryType
    typealias CompletionHandler = (_ error: Error?) -> ()
    
    private let category: Entity
    private let dataManager = DataManager.shared
    
    var id: String {
        return category.id
    }
    
    var title: String {
        return category.title
    }
    
    var categoryType: CategoryType  {
        let typeId = self.category.typeId
        guard let value = CategoryType(rawValue: typeId) else {
            return .none
        }
        return value
    }
    
    
    init(withCategory category: Entity) {
        self.category = category
    }
    
    func set(title: String) {
        dataManager.object(category, setValue: title, forKey: "title")
    }
    
    func set(categoryType: CategoryType) {
        dataManager.object(category, setValue: categoryType.rawValue, forKey: "typeId")
    }
    
    func save() {
        dataManager.save(category)
    }
    
    func remove(_ competion: CompletionHandler?) {
        dataManager.remove(category) { (error) in
            if let competion = competion {
                competion(error)
            }
        }
    }
}
