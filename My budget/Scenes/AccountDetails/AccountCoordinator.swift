//
//  AccountCoordinator.swift
//  My budget
//
//  Created by Nikolay Matorin on 26.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class AccountCoordinator: BaseCoordinator {
    
    private(set) lazy var navigationConttroller: UINavigationController = makeNavigationController()
    
    let repository: Repository
    
    let account: AccountDTO
    
    init(repository: Repository, account: AccountDTO) {
        self.repository = repository
        self.account = account
        super.init()
    }
    
    deinit {
        print(self, #function)
    }
    
    override func start() {
        showAccount()
    }
    
    private func showAccount() {
        let accountController = AccountContoller(repository: repository, account: account)
        let viewController = AccountViewController(accountContoller: accountController)
        viewController.delegate = self
        
        if accountController.isNewAccount {
            viewController.navigationItem.title = "new".combine(with: "account")
        } else {
            viewController.navigationItem.title = "account".localizeCapitalizingFirstLetter()
        }
        
        viewController.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close,
                                                                 target: self, action: #selector(finish))
        
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
    
    private func showCurrencies(selectedCurrencyCode: String?, delegate: CurrenciesViewControllerDelegate?) {
        let currencyViewController = CurrenciesViewController(selectedCurrencyCode: selectedCurrencyCode)
        currencyViewController.isModalInPresentation = true
        currencyViewController.delegate = delegate
        navigationConttroller.pushViewController(currencyViewController, animated: true)
    }
    
    @objc private func finish() {
        navigationConttroller.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.onComplete?(self)
        }
    }
}

extension AccountCoordinator: AccountViewControllerDelegate {
    func accountViewController(_ viewController: AccountViewController, didSelectCurrencyCode currencyCode: String?) {
        showCurrencies(selectedCurrencyCode: currencyCode, delegate: viewController)
    }
    
    func accountViewControllerDidSaveAccount(_ viewController: AccountViewController) {
        finish()
    }
}
