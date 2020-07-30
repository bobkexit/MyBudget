//
//  TransactionsCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionsCoordinator: BaseCoordinator {
    
    private(set) lazy var navigationConttroller: UINavigationController = makeNavigationController()
    
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
        super.init()
    }
    
    override func start() {
        showTransactions()
    }
    
    private func showTransactions() {
        let transactionsController = TransactionsController(repository: repository)
        let viewController = TransactionsViewController(transactionsController: transactionsController)

        viewController.actions = TransactionsViewController.Actions(
            createOperation: { [unowned self] in
                self.showOperationsMenu(for: viewController)
            },
            showFilters:  { [unowned self] in
                self.showFilters(for: viewController)
        })
        
        let title = "transactions".localizeCapitalizingFirstLetter()
        viewController.tabBarItem = UITabBarItem(title: title, image: .rubleSign, tag: 2)
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
    
    private func showOperationsMenu(for viewController: UIViewController) {
        
        let message = "select operation".localizeCapitalizingFirstLetter()
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
         
        let incomeOperation = makeAction(.income, for: viewController)
        let expenseOperation = makeAction(.expense, for: viewController)
        let transferOperation = makeAction(.interAccountTransfer, for: viewController)
        
        let cancel = UIAlertAction(title: "cancel".localizeCapitalizingFirstLetter(),
                                   style: .cancel, handler: nil)
    
        alert.addAction(transferOperation)
        alert.addAction(incomeOperation)
        alert.addAction(expenseOperation)
        alert.addAction(cancel)
        
        configure(actions: [transferOperation, incomeOperation, expenseOperation],
                  cancelAction: cancel,
                  for: viewController.traitCollection.userInterfaceStyle)
        
        viewController.present(alert, animated: true)
    }
    
    private func makeAction(_ operation:  OperationCoordinator.Operation, for viewController: UIViewController) -> UIAlertAction {
        return UIAlertAction(title: operation.rawValue.localizeCapitalizingFirstLetter(),
                             style: .default) { [unowned self] _ in
            let coordinator = OperationCoordinator(currentOperation: operation,
                                                   repository: self.repository)
            coordinator.onComplete = { [unowned self] child in
                self.remove(child)
            }
            self.add(coordinator)
            coordinator.start()
            viewController.present(coordinator.navigationConttroller, animated: true)
        }
    }
    
    private func configure(actions: [UIAlertAction], cancelAction: UIAlertAction, for style: UIUserInterfaceStyle) {
        let isDarkStyle = style == .dark
        let actionColor: UIColor = isDarkStyle ? .actionColor : .tertiaryTextColor
        let cancelColor: UIColor = isDarkStyle ? .negativeAccentColor : .systemRed
        
        actions.forEach { $0.setValue(actionColor, forKey: "titleTextColor")}
        cancelAction.setValue(cancelColor, forKey: "titleTextColor")
    }
    
    private func showFilters(for viewController: TransactionsViewController) {
        print("select show Fiters")
    }
}
