//
//  UpdatedTransactionVM.swift
//  My budget
//
//  Created by Николай Маторин on 25.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

class UpdatedTransactionVM: TransactionVM {
    
    override func set(_ value: Any?, forKey key: String) {
        super.set(value, forKey: key)
        save()
        
        let userInfo = [ "transactionId" : self.id ]
        NotificationCenter.default.post(name: .transaction, object: nil, userInfo: userInfo)
    }
}
