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
    
    var title: String? { object.title }
    
    var accountType: AccountType? { AccountType(rawValue: Int(object.typeId)) }
    
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
