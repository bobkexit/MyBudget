//
//  SettingsCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class SettingsCoordinator: BaseCoordinator {
    
    private(set) lazy var navigationConttroller: UINavigationController = makeNavigationController()
    
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
        super.init()
    }
    
    override func start() {
        showSettings()
    }
        
    private func showSettings() {
        let viewController = SettingsViewController()
        viewController.actions = SettingsViewController.Actions(
            didSelectSetting: { [unowned self] setting in
                self.show(setting)
        })
    
        let title = "settings".localizeCapitalizingFirstLetter()
        viewController.tabBarItem = UITabBarItem(title: title, image: .gearShape, tag: 3)
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
    
    private func show(_ setting: SettingsViewController.Item) {
        switch setting {
        case .accounts:
            showAccounts()
        case .expenses:
            showExpenses()
        case .incomes:
            showIncomes()
        }
    }
    
    private func showAccounts() {
        let accountsController = AccountsController(repository: repository)
        let viewController = AccountsViewController(accountsController: accountsController)
        viewController.actions.createOperation = { [weak self] in
            self?.showCreateAccountScene()
        }
        navigationConttroller.pushViewController(viewController, animated: true)
    }
    
    private func showCreateAccountScene() {
        let account = AccountDTO(account: AccountObject())
        let accountCoordinator = AccountCoordinator(repository: repository, account: account)
        accountCoordinator.onComplete = { [weak self] childCoordinator in
            self?.remove(childCoordinator)
        }
        add(accountCoordinator)
        accountCoordinator.start()
        navigationConttroller.present(accountCoordinator.navigationConttroller, animated: true)
    }
    
    private func showIncomes() {
        let viewController = makeCategoriesViewController(for: .income)
        navigationConttroller.pushViewController(viewController, animated: true)
    }
    
    private func showExpenses() {
        let viewController = makeCategoriesViewController(for: .expense)
        navigationConttroller.pushViewController(viewController, animated: true)
    }
    
    private func makeCategoriesViewController(for categoryType: CategoryKind) -> CategoriesViewController {
        let categoriesController = CategoriesController(categoryType: categoryType, repository: repository)
        let viewController = CategoriesViewController(categoriesController: categoriesController)
        switch categoryType {
        case .income:
            viewController.navigationItem.title = "incomes".localizeCapitalizingFirstLetter()
        case .expense:
            viewController.navigationItem.title = "expenses".localizeCapitalizingFirstLetter()
        }
        return viewController
    }
}
