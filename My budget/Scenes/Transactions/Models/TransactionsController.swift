//
//  TransactionsController.swift
//  My budget
//
//  Created by Николай Маторин on 17.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

protocol TransactionsControllerProtocol {
    var handlers: FetchDataHandlers { get set }
    func apply(_ filter: TransactionFilter?)
    func getDates() -> [Date]
    func getTransactions(for date: Date) -> [TransactionDTO]
    func delete(_ transaction: TransactionDTO) 
}

struct TransactionFilter {
    let account: AccountDTO?
    let startTime: Date?
    let endTime: Date?
}

struct FetchDataHandlers {
    var didFetchData: ((_ isFirstLoading: Bool) -> Void)?
    var didFail: ((_ error: Error) -> Void)?
}

class TransactionsController: TransactionsControllerProtocol {
    
    var handlers: FetchDataHandlers = FetchDataHandlers()
    
    private var notificationToken: NotificationToken?
    
    private let repository: Repository
    
    private lazy var results: Results<TransactionObject>  = fetchTransactions()
    
    init(repository: Repository) {
        self.repository = repository
        configureNotificationToken()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func apply(_ filter: TransactionFilter?) {
        results = fetchTransactions(with: filter)
        configureNotificationToken()
    }
    
    func getDates() -> [Date] {
        let dates = Set(results.map { Calendar.current.startOfDay(for: $0.date) })
        return Array(dates).sorted().reversed()
    }
    
    func getTransactions(for date: Date) -> [TransactionDTO] {
        let transactions = Array(results.compactMap { TransactionDTO(transaction: $0) })
        return transactions.filter { Calendar.current.isDate(date, inSameDayAs: $0.date) }
    }
    
    func delete(_ transaction: TransactionDTO) {
        guard let transaction = repository.find(TransactionObject.self, byID: transaction.id) else {
            return
        }
        
        do {
            try repository.remove(transaction)
        } catch let error {
            print("Failed to remove data = \(error)")
        }
    }
    
    private func fetchTransactions(with filter: TransactionFilter? = nil) -> Results<TransactionObject> {
        var results: Results<TransactionObject>
        
        if let accountDTO = filter?.account, let account = repository.find(AccountObject.self, byID: accountDTO.id) {
            results = account.transactions.sorted(byKeyPath: "date", ascending: true)
        } else {
            results = repository.fetch(TransactionObject.self).sorted(byKeyPath: "date", ascending: true)
        }
        
        if let starTime = filter?.startTime {
            let predicate = NSPredicate(format: "date >= %@", argumentArray: [starTime])
            results = results.filter(predicate)
        }
        
        if let endTime = filter?.endTime {
            let predicate = NSPredicate(format: "date <= %@", argumentArray: [endTime])
            results = results.filter(predicate)
        }
        
        return results
    }
    
    private func configureNotificationToken() {
        notificationToken?.invalidate()
        notificationToken = results.observe { [weak self] changes in
            guard let handlers = self?.handlers else { return }
            
            switch changes {
            case .initial:
                handlers.didFetchData?(true)
            case .update:
                handlers.didFetchData?(false)
            case .error(let err):
                handlers.didFail?(err)
            }
        }
    }
}
