//
//  BaseTableVC.swift
//  My budget
//
//  Created by Николай Маторин on 19.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class BaseTableVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tabBarController?.tabBar.selectedItem?.title

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        let colors = [#colorLiteral(red: 0.1215686275, green: 0.1568627451, blue: 0.1764705882, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.03137254902, blue: 0.03529411765, alpha: 1)]
        let backgroundView = UIView(frame: view.frame)
        let gradientLayer = CAGradientLayer(frame: backgroundView.frame, colors: colors)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
    }
}
