//
//  TransactionExt.swift
//  My budget
//
//  Created by Николай Маторин on 26.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

extension Transaction {
    public override func awakeFromInsert() {
        setPrimitiveValue(Date(), forKey: "date")
    }
}
