//
//  BalanceReport.swift
//  My budget
//
//  Created by Николай Маторин on 27.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

class BalanceReport: BaseReport {
    
    override var description: String {
        return NSLocalizedString("Balance", comment: "")
    }
    
    override func execute(_ completeion: Report.comletionHandler?) {
       
        let dataManager = BaseDataManager<Account>()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        
        var accounts: [SomeViewModel]!
        var total: Float = 0
        
        do {
            guard let data = try context.fetch(request) as? [Account] else {
                return
            }
            
            accounts = data.map({ AccountBalanceVM(object: $0, dataManager: dataManager) })
            data.forEach({
                if let amount = $0.transactions?.value(forKeyPath: "@sum.amount") as? NSNumber {
                  total += amount.floatValue
                }
            })
        } catch  {
            print(error as Any)
        }
        
        let result  = ["total" : total,
                       "accounts" : accounts] as [String : Any]
    
        if let completeion = completeion {
            completeion([result as AnyObject])
        }
    }
}
