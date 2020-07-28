//
//  OperationCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 18.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class OperationCoordinator: BaseCoordinator {
    enum Operation: String, CaseIterable {
        case interAccountTransfer = "inner transfer"
        case income = "income"
        case expense = "expense"
    }
    
    private let currentOperation: Operation
    
    private(set) lazy var navigationConttroller: UINavigationController = makeNavigationController()
    
    init(currentOperation: Operation) {
        self.currentOperation = currentOperation
        super.init()
    }
    
    deinit {
        print(#function, self)
    }
    
    override func start() {
        showOperation()
    }
    
    private func showOperation() {
        switch currentOperation {
        case .expense:
            showExpenseOperation()
        case .income:
            break
        case .interAccountTransfer:
            break
        }
    }
    
    private func showExpenseOperation() {
        //let accountController = AccountContoller(repository: repository, account: account)
        let viewController = ExpenseViewController()
//        viewController.delegate = self
        
//        if accountController.isNewAccount {
             viewController.navigationItem.title =  "new".combine(with: currentOperation.rawValue)
//            viewController.navigationItem.title = "new".combine(with: "account")
//        } else {
//            viewController.navigationItem.title = "account".localizeCapitalizingFirstLetter()
//        }
        
        viewController.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close,
                                                                 target: self, action: #selector(finish))
        
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
    
    @objc private func finish() {
        navigationConttroller.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.onComplete?(self)
        }
    }
}
