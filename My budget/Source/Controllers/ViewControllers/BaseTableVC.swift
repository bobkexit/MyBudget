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
        setup()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setup() {
        title = tabBarController?.tabBar.selectedItem?.title
        //setupView()
        setupTableView()
    }
    
    fileprivate func setupView() {
        let colors = [#colorLiteral(red: 0.1215686275, green: 0.1568627451, blue: 0.1764705882, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.03137254902, blue: 0.03529411765, alpha: 1)]
        let gradientLayer = CAGradientLayer(frame: self.view.bounds, colors: colors)
        gradientLayer.zPosition = -100
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    fileprivate func setupTableView() {
        setTableViewBackgroundGradient()
        tableView.separatorStyle = .none
    }
    
    fileprivate func setTableViewBackgroundGradient() {
        let gradientBackgroundColors = [#colorLiteral(red: 0.1215686275, green: 0.1568627451, blue: 0.1764705882, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.03137254902, blue: 0.03529411765, alpha: 1)]
        let gradientLayer = CAGradientLayer(frame: self.tableView.bounds, colors: gradientBackgroundColors)
    
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = backgroundView
    }
}
