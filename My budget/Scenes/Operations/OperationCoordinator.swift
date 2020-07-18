//
//  OperationCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 18.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class OperationCoordinator: BaseCoordinator {
    enum Operation: String, CaseIterable {
        case interAccountTransfer = "Inner transfer"
        case income = "Income"
        case expense = "Expense"
    }
    
    private let currentOperation: Operation
    
    private(set) lazy var navigationConttroller: UINavigationController = makeNavigationController()
    
    init(currentOperation: Operation) {
        self.currentOperation = currentOperation
        super.init()
    }
    
    deinit {
        print(#function, self)
    }
    
    override func start() {
        showEmptyScene()
    }
    
    private func showEmptyScene() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .richBlackForga30
        viewController.title = "Create " + currentOperation.rawValue
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
}
