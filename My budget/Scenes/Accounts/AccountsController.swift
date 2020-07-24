//
//  AccountsController.swift
//  My budget
//
//  Created by Николай Маторин on 22.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

protocol AccountsControllerProtocol: AnyObject {
    var handlers: FetchDataHandlers { get set }
    func getAccounts() -> [AccountDTO]
    func getAccounts(for type: AccountKind) -> [AccountDTO]
    func delete(_ account: AccountDTO)
}

class AccountsController: AccountsControllerProtocol {
    
    var handlers: FetchDataHandlers = FetchDataHandlers()
    
    private var notificationToken: NotificationToken?
    
    private let repository: Repository
    
    private lazy var results: Results<AccountObject> = fetchAccounts()
    
    init(repository: Repository) {
        self.repository = repository
        configureNotificationToken()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func getAccounts() -> [AccountDTO] {
        return results.compactMap { AccountDTO(account: $0) }
    }
    
    func getAccounts(for type: AccountKind) -> [AccountDTO] {
        let predicate = NSPredicate(format: "kind == %@", NSNumber(value: type.rawValue))
        let accounts = results.sorted(byKeyPath: "name").filter(predicate)
        return accounts.compactMap { AccountDTO(account: $0) }
    }
    
    func delete(_ account: AccountDTO) {
        guard let account = repository.find(AccountObject.self, byID: account.id) else { return }
        
        do {
            try repository.remove(account.transactions)
            try repository.remove(account)
        } catch let error {
            print("Failed to remove data = \(error)")
        }
    }
    
    private func fetchAccounts() -> Results<AccountObject> {
        return repository.fetch(AccountObject.self)
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
