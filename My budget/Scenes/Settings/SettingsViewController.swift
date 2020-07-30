//
//  SettingsViewController.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    struct Actions {
        var didSelectSetting: ((_ setting: Item) -> Void)?
    }
    
    enum Section: String, CaseIterable {
        case accounts
        case categories
    }
    
    enum Item: String, CaseIterable {
        case accounts
        case incomes
        case expenses
    }
    
    var actions: Actions = Actions()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = makeDataSource()
    
    private let reuseIdentifier = "SettingCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width:  tableView.frame.size.width, height: 60.0)))
        return tableView
    } ()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "settings".localizeCapitalizingFirstLetter()
        navigationItem.largeTitleDisplayMode = .always
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        configureViews()
        updateUI()
    }
    
    private func configureViews() {
        view.backgroundColor = .primaryBackgroundColor
        view.addSubview(tableView)
       
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension SettingsViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Section, Item> {
        let reuseIdentifier = self.reuseIdentifier
        return UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { tableView, indexPath, item -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            cell.textLabel?.text = item.rawValue.localizeCapitalizingFirstLetter()
            cell.textLabel?.textColor = .primaryTextColor
            cell.backgroundColor = .secondaryBackgroundColor
            cell.accessoryType = .disclosureIndicator
            cell.setSelectionColor()           
            return cell
        }
    }
    
    func updateUI(animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([.accounts], toSection: .accounts)
        snapshot.appendItems([.incomes, .expenses], toSection: .categories)
    
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        actions.didSelectSetting?(item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
