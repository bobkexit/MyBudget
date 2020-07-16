//
//  DataManagerFactory.swift
//  My budget
//
//  Created by Николай Маторин on 23.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

enum EntityType {
    case account
    case category
    case incomeCategory
    case expenseCategory
    case transaction
}

final class DataManagerFactory {
    public static let shared = DataManagerFactory()
    
    private init() {
        
    }
    
    func createDataManager<Entity: NSManagedObject>(forEntity entity: EntityType) -> BaseDataManager<Entity>? {
        
        switch entity {
        case .account:
            return BaseDataManager<Account>() as? BaseDataManager<Entity>
        case .category:
            return BaseDataManager<Category>() as? BaseDataManager<Entity>
        case .expenseCategory:
            return ExpenseCategoryManager() as? BaseDataManager<Entity>
        case .incomeCategory:
            return IncomeCategoryManager() as? BaseDataManager<Entity>
        case .transaction:
            return BaseDataManager<Transaction>() as? BaseDataManager<Entity>
        }
        
    }
}
