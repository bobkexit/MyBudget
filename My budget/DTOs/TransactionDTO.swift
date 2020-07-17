//
//  TransactionDTO.swift
//  My budget
//
//  Created by Николай Маторин on 17.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation

struct TransactionDTO: Hashable {
    let id: String
    let date: Date
    let account: AccountDTO?
    let category: CategoryDTO?
    let ammount: Float
    let comment: String
}

extension TransactionDTO {
    func copy(date: Date? = nil,
              account: AccountDTO? = nil,
              category: CategoryDTO? = nil,
              ammount: Float? = nil,
              comment: String? = nil) -> TransactionDTO {
        return TransactionDTO(id: id,
                              date: date ?? self.date,
                              account: account ?? self.account,
                              category: category ?? self.category,
                              ammount: ammount ?? self.ammount,
                              comment: comment ?? self.comment)
    }
    
    init(transaction: TransactionObject) {
        self.id = transaction.id
        self.date = transaction.date
        self.account =  transaction.account != nil ? AccountDTO(account: transaction.account!) : nil
        self.category = transaction.category != nil ? CategoryDTO(category: transaction.category!) : nil
        self.ammount = transaction.ammount
        self.comment = transaction.comment
    }
}
