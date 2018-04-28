//
//  AccountViewModel.swift
//  My budget
//
//  Created by Николай Маторин on 11.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

class AccountVM: BaseViewModel<Account> {
   
    // MARK: - Public Properties
    
    var id: URL {
        let objectID = object.objectID
        let url = objectID.uriRepresentation()
        return url
    }
    
    var title: String? {
        return self.object.title
    }
    
    var accountType: AccountType {
        let typeId = Int(self.object.typeId)
        
        guard let value = AccountType(rawValue: typeId) else {
            fatalError("Incorrect aacount typeId")
        }
        
        return value
    }
    
    // MARK: - Setters
    
    override func set(_ value: Any?, forKey key: String) {
        
        var rawValue = value
        var rawKey = key
        
        if key.lowercased() == "accounttype", let accountType = value as? AccountType  {
            rawKey = "typeId"
            rawValue = Int16(accountType.rawValue)
        }
        
        super.set(rawValue, forKey: rawKey)
    }
}
