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
    var handlers: TransactionsHandlers? { get set }
    func apply(_ filter: TransactionFilter?)
    func getDates() -> [Date]
    func getTransactions(for date: Date) -> [TransactionDTO]
}

struct TransactionFilter {
    let account: AccountDTO?
    let startTime: Date?
    let endTime: Date?
}

struct TransactionsHandlers {
    var didFetchTransactions: ((_ isFirstLoading: Bool) -> Void)?
    var didFail: ((_ error: Error) -> Void)?
}

class TransactionsController: TransactionsControllerProtocol {
    
    var handlers: TransactionsHandlers?
    
    private var notificationToken: NotificationToken?
    
    private let repository: Repository
    
    private lazy var results = fetchTransactions()
    
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
        return Array(dates)
    }
    
    func getTransactions(for date: Date) -> [TransactionDTO] {
        let transactions = Array(results.compactMap { TransactionDTO(transaction: $0) })
        return transactions.filter { Calendar.current.isDate(date, inSameDayAs: $0.date) }
    }
    
    private func fetchTransactions(with filter: TransactionFilter? = nil) -> Results<TransactionObject> {
        var results: Results<TransactionObject>
        
        if let accountDTO = filter?.account, let account = repository.find(AccountObject.self, byID: accountDTO.id) {
            results = account.transactions.sorted(byKeyPath: "date")
        } else {
            results = repository.fetch(TransactionObject.self).sorted(byKeyPath: "date")
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
                handlers.didFetchTransactions?(true)
            case .update:
                handlers.didFetchTransactions?(false)
            case .error(let err):
                handlers.didFail?(err)
            }
        }
    }
}
