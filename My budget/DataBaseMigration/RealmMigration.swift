//
//  RealmMigration.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData
import RealmSwift


protocol DataBaseMigration: AnyObject {
    func migrate()
}

protocol RealmMigrationDelegate: AnyObject {
    func realmMigrationDidStart(_ migration: RealmMigration)
    func realmMigration(_ migration: RealmMigration, didFailWithError error: Error)
    func realmMigrationDidFinish(_ migration: RealmMigration)
}

class RealmMigration: DataBaseMigration {
    
    public weak var delegate: RealmMigrationDelegate?
    
    private let viewContext: NSManagedObjectContext
    private let realm: Realm
    private let userDefaults = UserDefaults.standard
    
    private var categoriesMigration: [Category: CategoryObject] = [:]
    private var accountsMigration: [Account: AccountObject] = [:]
    private var transactionsMigration: [Transaction: TransactionObject] = [:]
    
    
    private(set) var isCompleted: Bool {
        get { UserDefaults.standard.bool(forKey: "isCompleteMigration") }
        set { UserDefaults.standard.set(newValue, forKey: "isCompleteMigration") }
    }
    
    init(viewContext: NSManagedObjectContext,  realm: Realm) {
        self.viewContext = viewContext
        self.realm = realm
    }
    
    func migrate() {
        delegate?.realmMigrationDidStart(self)
        
        if !isCompleted {
            migrateCategories()
            migrateAccounts()
            migrateTransactions()
            commitMigration()
        }
        
        delegate?.realmMigrationDidFinish(self)
    }
    
    func reset() {
        try? realm.write {
            realm.deleteAll()
        }
        
        isCompleted = false
    }
    
    private func migrateCategories() {
        let categoriesFetchRequest = NSFetchRequest<Category>(entityName: "Category")
        do {
            let categories = try viewContext.fetch(categoriesFetchRequest)
            
            var expenseSortIndex = 1
            var incomeSortIndex = 1
            
            categories.forEach {
                let newCategory = CategoryObject()
                newCategory.name = $0.title ?? "New category"
               
                let categoryType = CategoryType(rawValue: Int($0.typeId))!
                switch categoryType {
                case .credit:
                    newCategory.kind = CategoryKind.expense.rawValue
                    newCategory.sortIndex = expenseSortIndex
                    expenseSortIndex += 1
                case .debit:
                    newCategory.kind = CategoryKind.income.rawValue
                    newCategory.sortIndex = incomeSortIndex
                    incomeSortIndex += 1
                }
            
                categoriesMigration[$0] = newCategory
            }
        } catch let error as NSError {
            delegate?.realmMigration(self, didFailWithError: error)
        }
    }
    
    private func migrateAccounts() {
        let accountFetchRequest = NSFetchRequest<Account>(entityName: "Account")
        do {
            let accounts = try viewContext.fetch(accountFetchRequest)
            
            accounts.forEach {
                
                let newAccount = AccountObject()
                newAccount.name = $0.title ?? "New Account"
                
                if let accountType = AccountType(rawValue: Int($0.typeId)) {
                    switch accountType {
                    case .cash:
                        newAccount.kind = AccountKind.cash.rawValue
                    case .paymentCard:
                        newAccount.kind = AccountKind.bankCard.rawValue
                    case .bankAccont:
                        newAccount.kind = AccountKind.bankAccount.rawValue
                    default:
                        break
                    }
                }
                
                accountsMigration[$0] = newAccount
                
                print(accountsMigration.values)
            }
            
        } catch let error as NSError {
            delegate?.realmMigration(self, didFailWithError: error)
        }
    }
    
    private func migrateTransactions() {
        let transactionsFetchRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
        do {
            let transactions = try viewContext.fetch(transactionsFetchRequest)
            
            transactions.forEach {
                
                if let date = $0.date,
                    let transactionCategory = $0.category,
                    let category = categoriesMigration[transactionCategory],
                    let transactionAccount = $0.account,
                    let account = accountsMigration[transactionAccount] {
                    
                    let newTransaction = TransactionObject()
                    newTransaction.date = date
                    newTransaction.ammount = abs($0.amount)
                    newTransaction.category = category
                    newTransaction.account = account
                    newTransaction.comment = $0.comment ?? ""
                    
                    transactionsMigration[$0] = newTransaction
                }
                
                print(transactionsMigration.values)
            }
            
        } catch let error as NSError {
            delegate?.realmMigration(self, didFailWithError: error)
        }
    }
    
    private func commitMigration() {
        do {
            try realm.write {
                realm.add(categoriesMigration.values)
                realm.add(accountsMigration.values)
                realm.add(transactionsMigration.values)
            }
            isCompleted = true
        } catch let error as NSError  {
            isCompleted = false
            delegate?.realmMigration(self, didFailWithError: error)
        }
    }
    
    private func printRealm() {
        let categories = realm.objects(CategoryObject.self)
        let accounts = realm.objects(AccountObject.self)
        let transactions = realm.objects(TransactionObject.self)
        
        print("---- Categories ----")
        print(categories)
        print("---- Accounts ----")
        print(accounts)
        print("---- Transactions ----")
        print(transactions)
    }
}
