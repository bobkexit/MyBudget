//
//  AppCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class AppCoordinator: BaseCoordinator {
    
    private var window: UIWindow
    
    private let persistentContainer: NSPersistentContainer
    
    private let realm: Realm
    
    private lazy var migration = RealmMigration(viewContext: persistentContainer.viewContext, realm: realm)
    
    private lazy var rootViewController: UITabBarController = UITabBarController()
    
    init(window: UIWindow, realm: Realm, persistentContainer: NSPersistentContainer) {
        self.window = window
        self.persistentContainer = persistentContainer
        self.realm = realm
    }
    
    override func start() {
        migration.isCompleted ? showMainScene() : showLoadingScene()
        window.makeKeyAndVisible()
    }
            
    private func showLoadingScene() {
        let viewController = LoadingViewController()
        
        let presenter = LoadingPresenter(migration: migration, view: viewController) { [unowned self] in
            self.showMainScene()
        }
        migration.delegate = presenter
        viewController.presenter = presenter
        
        window.rootViewController = viewController
    }
    
    private func showMainScene() {
        configureMainScene()
        window.rootViewController = rootViewController
    }
    
    private func configureMainScene() {
        var viewControllers: [UINavigationController] = []
        
        let reportsCoordinator = ReportsCoordinator(navigationConttroller: makeNavigationController())
        viewControllers.append(reportsCoordinator.navigationConttroller)
        
        let transactionsCoordinator = TransactionsCoordinator(navigationConttroller: makeNavigationController())
        viewControllers.append(transactionsCoordinator.navigationConttroller)
        
        let settingsCoordinator = SettingsCoordinator(navigationConttroller: makeNavigationController())
        viewControllers.append(settingsCoordinator.navigationConttroller)
      
        add(transactionsCoordinator, reportsCoordinator, settingsCoordinator)
        
        rootViewController.setViewControllers(viewControllers, animated: false)
        rootViewController.tabBar.tintColor = .orangePeel
        rootViewController.tabBar.barTintColor = .richBlackForga29
        rootViewController.selectedIndex = 1
    }
    
    private func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.babyPowder]
        appearance.largeTitleTextAttributes = textAttributes
        appearance.titleTextAttributes = textAttributes
    
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.tintColor = .orangePeel
        
        return navigationController
    }
}
