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
    
    init(navigationConttroller: UINavigationController) {
        self.navigationConttroller = navigationConttroller
        super.init()
    }
    
    override func start() {
        showTransactions()
    }
    
    private func showTransactions() {
        let viewController = TransactionsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Transactions", image: .rubleSign, tag: 2)
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
}
