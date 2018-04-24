//
//  DataManager.swift
//  My budget
//
//  Created by Николай Маторин on 20.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

protocol DataManager {
    
    associatedtype Entity
    
    func getObjects() -> [Entity]
    
    func findObject(by url: URL) -> Entity?
    
    func create() -> Entity
    
    func createArray() -> [Entity]
    
    func add(object: Entity)
    
    func delete(object: Entity)
    
    func saveContext()
}
