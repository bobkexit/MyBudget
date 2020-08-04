//
//  IncomeExpenseOperation.swift
//  My budget
//
//  Created by Nikolay Matorin on 04.08.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

protocol IncomeExpenseOperation: AnyObject {
    var date: Date { get }
    var type: CategoryKind { get }
    var category: CategoryDTO? { get }
    var account: AccountDTO? { get }
    var amount: Float { get }
    var comment: String? { get }
    var isNew: Bool { get }
    
    func update(date: Date)
    func update(category: CategoryDTO)
    func update(account: AccountDTO)
    func update(amount: Float)
    func update(comment: String)
    
    func save()
}

class IncomeExpenseOperationController: IncomeExpenseOperation {

    var date: Date { transaction.date }
    
    var category: CategoryDTO? { transaction.category }
    
    var account: AccountDTO? { transaction.account }
    
    var amount: Float { transaction.amount }
    
    var comment: String? { transaction.comment }
    
    var isNew: Bool { repository.find(TransactionObject.self, byID: transaction.id) == nil }
    
    let type: CategoryKind
    
    private var transaction: TransactionDTO
        
    private let repository: Repository
    
    init(type: CategoryKind, repository: Repository, transaction: TransactionDTO? = nil) {
        self.type = type
        self.repository = repository
        self.transaction = transaction ?? TransactionDTO(transaction: TransactionObject())
    }
    
    func update(date: Date) {
        self.transaction = transaction.copy(date: date)
    }
    
    func update(category: CategoryDTO) {
        self.transaction = transaction.copy(category: category)
    }
    
    func update(account: AccountDTO) {
        self.transaction = transaction.copy(account: account)
    }
    
    func update(amount: Float) {
        self.transaction = transaction.copy(amount: amount)
    }
    
    func update(comment: String) {
        self.transaction = transaction.copy(comment: comment)
    }
    
    func save() {
        guard let category = repository.find(CategoryObject.self, byID: transaction.category?.id ?? ""),
            let account = repository.find(AccountObject.self, byID: transaction.account?.id ?? "") else { return }
        
        
        if let transactionObject = repository.find(TransactionObject.self, byID: transaction.id) {
            repository.update { [transaction] in
                transactionObject.account = account
                transactionObject.category = category
                transactionObject.amount = transaction.amount
                transactionObject.comment = transaction.comment
            }
        } else {
            let transactionObject = TransactionObject()
            transactionObject.id = transaction.id
            transactionObject.account = account
            transactionObject.category = category
            transactionObject.amount = amount
            transactionObject.date = transaction.date
            transactionObject.comment = transaction.comment
            
            do {
                try repository.save(transactionObject)
            } catch let error {
                print("Failed to save transaction: \(transaction). Error: \(error)")
            }
        }
    }
}
