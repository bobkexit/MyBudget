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
        navigationConttroller.pushViewController(viewController, animated: true)
    }
    
    private func showIncomes() {
        let viewController = UIViewController()
        viewController.navigationItem.title = "Incomes"
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.view.backgroundColor = .yellow
        
        navigationConttroller.pushViewController(viewController, animated: true)
    }
    
    private func showExpenses() {
        let viewController = UIViewController()
        viewController.navigationItem.title = "Expenses"
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.view.backgroundColor = .green
        
        navigationConttroller.pushViewController(viewController, animated: true)
    }
}
