//
//  OperationCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 18.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

protocol OperationCoordinatorDelegate: AnyObject {
    func operationCoordinator(_ coordinator: OperationCoordinator, didSelectAccount account: AccountDTO)
    func operationCoordinator(_ coordinator: OperationCoordinator, didSelectCategory category: CategoryDTO)
}

class OperationCoordinator: BaseCoordinator {
    enum Operation: String, CaseIterable {
        case interAccountTransfer = "inner transfer"
        case income = "income"
        case expense = "expense"
    }
    
    private weak var delegate: OperationCoordinatorDelegate?
    
    private let currentOperation: Operation
    
    private(set) lazy var navigationConttroller: UINavigationController = makeNavigationController()
    
    let repository: Repository
    
    init(currentOperation: Operation, repository: Repository) {
        self.currentOperation = currentOperation
        self.repository = repository
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
        viewController.delegate = self
        delegate = viewController
        
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
    
    private func showCreateAccount() {
         let account = AccountDTO(account: AccountObject())
        let accountCoordinator = AccountCoordinator(repository: repository, account: account)
        accountCoordinator.onComplete = { [weak self] childCoordinator in
            self?.remove(childCoordinator)
        }
        add(accountCoordinator)
        accountCoordinator.start()
        navigationConttroller.present(accountCoordinator.navigationConttroller, animated: true)
    }
    
    private func showCategories(selectedCategory: CategoryDTO?, categoryType: CategoryKind) {
        let viewController = makeCategoriesViewController(for: categoryType,
                                                          repository: repository,
                                                          selectedCategory: selectedCategory)
        viewController.canEditRow = false
        viewController.delegate = self
        navigationConttroller.pushViewController(viewController, animated: true)
    }
       
    
    @objc private func finish() {
        navigationConttroller.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.onComplete?(self)
        }
    }
}

extension OperationCoordinator: ExpenseViewControllerDelegate {
    func expenseViewController(_ viewController: ExpenseViewController, didSelectAccount account: AccountDTO?) {
        let accountsController = AccountsController(repository: repository)
        let viewController = AccountsViewController(accountsController: accountsController, selectedAccount: account)
        viewController.delegate = self
        navigationConttroller.pushViewController(viewController, animated: true)
    }
    
    func expenseViewController(_ viewController: ExpenseViewController, didSelectCategory category: CategoryDTO?) {
        switch currentOperation {
        case .expense:
            showCategories(selectedCategory: category, categoryType: .expense)
        case .income:
            showCategories(selectedCategory: category, categoryType: .income)
        case .interAccountTransfer:
            break
        }
    }
    
    func expenseViewControllerDidSaveTransaction(_ viewController: ExpenseViewController) {
        finish()
    }
}

extension OperationCoordinator: CategoriesViewControllerDelegate {
    func categoriesViewController(_ viewController: CategoriesViewController, didSelectCategory category: CategoryDTO) {
        navigationConttroller.popViewController(animated: true)
        delegate?.operationCoordinator(self, didSelectCategory: category)
    }
}

extension OperationCoordinator: AccountsViewControllerDelegate {
    func accountsViewControllerDidSelectCreateAccount(_ viewController: AccountsViewController) {
        showCreateAccount()
    }
    
    func accountsViewController(_ viewController: AccountsViewController, didSelectAccount account: AccountDTO) {
        navigationConttroller.popViewController(animated: true)
        delegate?.operationCoordinator(self, didSelectAccount: account)
    }    
}
