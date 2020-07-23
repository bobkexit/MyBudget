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
        case interAccountTransfer = "inner transfer"
        case income = "income"
        case expense = "expense"
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
        let title = "new".combine(with: currentOperation.rawValue)
        let viewController = UIViewController()
        viewController.view.backgroundColor = .richBlackForga30
        viewController.navigationItem.title = title
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close, target: nil, action: nil)
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
}
