//
//  TransactionsViewController.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Transactions"
        view.backgroundColor = .richBlackForga30
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.babyPowder]
        appearance.largeTitleTextAttributes = textAttributes
        appearance.titleTextAttributes = textAttributes
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
}
