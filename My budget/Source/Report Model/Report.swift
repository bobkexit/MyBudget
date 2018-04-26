//
//  Report.swift
//  My budget
//
//  Created by Николай Маторин on 26.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

protocol Report: CustomStringConvertible {
    typealias comletionHandler = (_ results: [AnyObject]?) -> ()
    
    var context: NSManagedObjectContext { get }
    
    var entityName: String { get }
    
    init(entityName: String, context: NSManagedObjectContext)
    
    func execute(_ completeion: comletionHandler?)
}
