//
//  AppCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    private var window: UIWindow
    
    private lazy var rootViewController: UITabBarController = UITabBarController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        configureRootViewController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    private func configureRootViewController() {
        var viewControllers: [UINavigationController] = []
        
        let transactionsCoordinator = TransactionsCoordinator()
        viewControllers.append(transactionsCoordinator.navigationConttroller)
        transactionsCoordinator.start()
        add(transactionsCoordinator)
        
        let reportsCoordinator = ReportsCoordinator()
        viewControllers.append(reportsCoordinator.navigationConttroller)
        reportsCoordinator.start()
        add(reportsCoordinator)
        
        
        let settingsCoordinator = SettingsCoordinator()
        viewControllers.append(settingsCoordinator.navigationConttroller)
        settingsCoordinator.start()
        add(settingsCoordinator)
        
        rootViewController.setViewControllers(viewControllers, animated: true)
    }
    
}
