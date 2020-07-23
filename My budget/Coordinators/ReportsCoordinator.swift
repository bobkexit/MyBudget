//
//  ReportsCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class ReportsCoordinator: BaseCoordinator {
    
    private(set) lazy var navigationConttroller: UINavigationController = makeNavigationController()
        
    override func start() {
        showReports()
    }
    
    private func showReports() {
        let viewController = ReportsViewController()
        viewController.tabBarItem = UITabBarItem(title: "reports".localizeCapitalizingFirstLetter(),
                                                 image: .chartBarDocHorizontal, tag: 1)
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
}
