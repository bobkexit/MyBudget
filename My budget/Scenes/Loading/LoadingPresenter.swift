//
//  LoadingPresenter.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation

protocol LoadingViewProtocol: AnyObject {
    func start()
    func stop()
    func showError(_ error: Error)
}

protocol LoadingPresenterProtocol: AnyObject {
    func start()
}

class LoadingPresenter: LoadingPresenterProtocol {
    
    private let migration: DataBaseMigration

    private var hasErrors: Bool = false
    
    private weak var view: LoadingViewProtocol?
    
    public var onSuccess: (() -> Void)?
    
    init(migration: DataBaseMigration, view: LoadingViewProtocol? = nil, onSuccess: (() -> Void)? = nil) {
        self.migration = migration
        self.onSuccess = onSuccess
        self.view = view
    }
    
    public func start() {
        migration.migrate()
    }
}

extension LoadingPresenter: RealmMigrationDelegate {
    func realmMigrationDidStart(_ migration: RealmMigration) {
        hasErrors = false
        view?.start()
    }
    
    func realmMigration(_ migration: RealmMigration, didFailWithError error: Error) {
        hasErrors = true
        view?.showError(error)
    }
    
    func realmMigrationDidFinish(_ migration: RealmMigration) {
        view?.stop()
        if !hasErrors {
            onSuccess?()
        }
    }
}
