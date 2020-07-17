//
//  AccountDTO.swift
//  My budget
//
//  Created by Николай Маторин on 17.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation

struct AccountDTO: Hashable {
    let id: String
    let name: String
    let kind: AccountKind
    let currencyCode: String?
}

extension AccountDTO {
    func copy(name: String? = nil, kind: AccountKind? = nil, currencyCode: String? = nil) -> AccountDTO {
        return AccountDTO(id: id,
                          name: name ?? self.name,
                          kind: kind ?? self.kind,
                          currencyCode: currencyCode ?? self.currencyCode)
    }
    
    init(account: AccountObject) {
        self.id = account.id
        self.name = account.name
        self.kind = AccountKind(rawValue: account.kind)!
        self.currencyCode = account.currencyCode
    }
}
