//
//  BaseReport.swift
//  My budget
//
//  Created by Николай Маторин on 27.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

class BaseReport: Report {
    
    let context: NSManagedObjectContext
    
    let entityName: String
    
    required init(entityName: String, context: NSManagedObjectContext) {
        self.entityName = entityName
        self.context = context
    }
    
    func execute(_ completeion: Report.comletionHandler?) {
        fatalError("Abstract method")
    }
    
    var description: String {
        return ""
    }
}
