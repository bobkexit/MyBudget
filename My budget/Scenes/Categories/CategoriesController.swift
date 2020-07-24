//
//  CategoriesController.swift
//  My budget
//
//  Created by Nikolay Matorin on 23.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

protocol CategoriesControllerProtocol: AnyObject {
    var handlers: CategoriesHandlers { get set }
    func getCategories(filteredByName name: String?) -> [CategoryDTO]
    func createCategory(withName name: String) -> CategoryDTO
    func save(_ category: CategoryDTO)
    func delete(_ category: CategoryDTO)
}

struct CategoriesHandlers {
    var didFetchCategories: (() -> Void)?
    var didUpdateCategories: (() -> Void)?
    var didDeleteCategories: (() -> Void)?
    var didInsertCategories: (() -> Void)?
    var didFail: ((_ error: Error) -> Void)?
}

class CategoriesController: CategoriesControllerProtocol {
    
    var handlers: CategoriesHandlers = CategoriesHandlers()
    
    private var notificationToken: NotificationToken?
    
    private let categoryType: CategoryKind
    
    private let repository: Repository
    
    private lazy var results: Results<CategoryObject> = fetchCategories()
    
    init(categoryType: CategoryKind, repository: Repository) {
        self.categoryType = categoryType
        self.repository = repository
        configureNotificationToken()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func getCategories(filteredByName name: String?) -> [CategoryDTO] {
        if let name = name, !name.isEmpty {
            let predicate = NSPredicate(format: "name CONTAINS %@", name)
            return results
                .filter(predicate)
                .sorted(byKeyPath: "sortIndex")
                .compactMap { CategoryDTO(category: $0) }
        } else {
            return results
                .sorted(byKeyPath: "sortIndex")
                .compactMap { CategoryDTO(category: $0) }
        }
    }
    
    func createCategory(withName name: String) -> CategoryDTO {
        let category = CategoryObject()
        category.name = name
        category.kind = categoryType.rawValue
        return CategoryDTO(category: category)
    }
    
    func save(_ category: CategoryDTO) {
        if let categoryObject = repository.find(CategoryObject.self, byID: category.id) {
            repository.update {
                categoryObject.name = category.name.trimmingCharacters(in: .whitespaces)
            }
        } else {
            let categoryObject = CategoryObject()
            categoryObject.id = category.id
            categoryObject.name = category.name.trimmingCharacters(in: .whitespaces)
            categoryObject.kind = categoryType.rawValue
            categoryObject.sortIndex = results.count + 1
            
            do {
                try repository.save(categoryObject)
            } catch let error {
                print("Failed to save category = \(category), error = \(error)")
            }
        }
    }

    func delete(_ category: CategoryDTO) {
        guard let category = repository.find(CategoryObject.self, byID: category.id) else { return }
        
        do {
            try repository.remove(category.transactions)
            try repository.remove(category)
        } catch let error {
            print("Failed to remove data = \(error)")
        }
    }
    
    private func fetchCategories() -> Results<CategoryObject> {
        let predicate = NSPredicate(format: "kind == %@", NSNumber(value: categoryType.rawValue))
        return repository.fetch(CategoryObject.self).filter(predicate).sorted(byKeyPath: "sortIndex")
    }
    
    private func configureNotificationToken() {
        notificationToken?.invalidate()
        notificationToken = results.observe { [weak self] changes in
            guard let handlers = self?.handlers else { return }
            
            switch changes {
            case .initial:
                handlers.didFetchCategories?()
            case .update(_, let deletions, let insertions, let modifications):
                if insertions.count > 0 {
                    handlers.didInsertCategories?()
                }
                
                if modifications.count > 0 {
                    handlers.didUpdateCategories?()
                }
                
                if deletions.count > 0 {
                    handlers.didDeleteCategories?()
                }
            case .error(let err):
                handlers.didFail?(err)
            }
        }
    }
}
