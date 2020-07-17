//
//  TransactionsCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionsCoordinator: BaseCoordinator {
    
    let navigationConttroller: UINavigationController
    
    let repository: Repository
    
    init(navigationConttroller: UINavigationController, repository: Repository) {
        self.navigationConttroller = navigationConttroller
        self.repository = repository
        super.init()
    }
    
    override func start() {
        showTransactions()
    }
    
    private func showTransactions() {
        let transactionsController = TransactionsController(repository: repository)
        let viewController = TransactionsViewController(transactionsController: transactionsController)
        viewController.tabBarItem = UITabBarItem(title: "Transactions", image: .rubleSign, tag: 2)
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
}
