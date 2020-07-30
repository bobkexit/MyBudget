//
//  BaseTableViewController.swift
//  My budget
//
//  Created by Николай Маторин on 29.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class BaseTableViewController: UIViewController {
    
    private var style: UITableView.Style = .plain
    
    private(set) lazy var tableView: UITableView = makeTableView()
    
    private(set) lazy var searchController: UISearchController = makeSearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackgroundColor
        
        configureNavigationBar()
        configureTableView()
        
        definesPresentationContext = true
    }
    
    convenience init(style: UITableView.Style) {
        self.init()
        self.style = style
    }
    
    func updateUI(animated: Bool = false) { }
    
    func performSearch(with searchText: String?, animated: Bool) { }
    
    func configureNavigationBar() { }
    
    func configureTableView() { }
    
    private func makeSearchController() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        return searchController
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: style)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return tableView
    }
}

extension BaseTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        performSearch(with: searchController.searchBar.text, animated: true)
    }
}
