//
//  NotificationNameExt.swift
//  My budget
//
//  Created by Николай Маторин on 03.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let account = Notification.Name(rawValue: "account")
    static let transaction = Notification.Name(rawValue: "transaction")
    
    static let accountHasBeenCreated =  Notification.Name(rawValue: "accountHasBeenCreated")
    static let accountHasBeenUpdated =  Notification.Name(rawValue: "accountHasBeenUpdated")
    static let accountHasBeenDeleted =  Notification.Name(rawValue: "accountHasBeenDeleted")
    
    static let categoryHasBeenCreated =  Notification.Name(rawValue: "categoryHasBeenCreated")
    static let categoryHasBeenUpdated =  Notification.Name(rawValue: "categoryHasBeenUpdated")
    static let categoryHasBeenDeleted =  Notification.Name(rawValue: "categoryHasBeenDeleted")
    
    static let transactionHasBeenCreated =  Notification.Name(rawValue: "transactionHasBeenCreated")
    static let transactionHasBeenUpdated =  Notification.Name(rawValue: "transactionHasBeenUpdated")
    static let transactionHasBeenDeleted =  Notification.Name(rawValue: "transactionHasBeenDeleted")
}
