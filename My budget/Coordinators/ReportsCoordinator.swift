//
//  ReportsCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class ReportsCoordinator: BaseCoordinator {
    
    private(set) lazy var navigationConttroller: UINavigationController = UINavigationController()
    
    override func start() {
        configureNavigationConttroller()
        showReports()
    }
    
    private func configureNavigationConttroller() {
        
    }
    
    private func showReports() {
        let viewController = ReportsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Reports", image: .chartBarDocHorizontal, tag: 1)
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
}
