//
//  TransactionsCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionsCoordinator: BaseCoordinator {
    
    private(set) lazy var navigationConttroller: UINavigationController = UINavigationController()
    
    override func start() {
        configureNavigationConttroller()
        showTransactions()
    }
    
    private func configureNavigationConttroller() {
        
    }
    
    private func showTransactions() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .orange
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
}
