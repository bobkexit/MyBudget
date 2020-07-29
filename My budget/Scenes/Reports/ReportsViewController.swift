//
//  ReportsViewController.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class ReportsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .primaryBackgroundColor
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "reports".localizeCapitalizingFirstLetter()
    }
}
