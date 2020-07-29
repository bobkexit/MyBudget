//
//  AccountsViewController.swift
//  My budget
//
//  Created by Николай Маторин on 22.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

protocol AccountsViewControllerDelegate: AnyObject {
    func accountsViewControllerDidSelectCreateAccount(_ viewController: AccountsViewController)
    func accountsViewController(_ viewController: AccountsViewController, didSelectAccount account: AccountDTO)
}

class AccountsViewController: UIViewController {
   
    weak var delegate: AccountsViewControllerDelegate?

    var accountsController: AccountsControllerProtocol!
    
    private let cellReuseIdentifier = "AccountCell"
    
    private lazy var dataSource: AccountsDataSource = makeDataSource()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width:  tableView.frame.size.width, height: 60.0)))
        return tableView
    } ()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.plus, for: .normal)
        button.backgroundColor = .actionColor
        button.tintColor = .primaryBackgroundColor
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        return button
    } ()
    
    convenience init(accountsController: AccountsControllerProtocol) {
        self.init()
        self.accountsController = accountsController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        accountsController?.handlers = FetchDataHandlers(
            didFetchData: { [weak self] isFirstLoading in
                self?.updateUI(animated: !isFirstLoading)
            }, didFail: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.layer.cornerRadius = addButton.bounds.height / 2
    }
    
    @objc private func addButtonTapped(_ sender: UIButton) {
        delegate?.accountsViewControllerDidSelectCreateAccount(self)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Accounts"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem?.tintColor = .primaryTextColor
    }
    
    private func configureViews() {
        view.backgroundColor = .primaryBackgroundColor
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 48.0),
            addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

private extension AccountsViewController {
    func makeDataSource() -> AccountsDataSource {
        let dataSource = AccountsDataSource(tableView: tableView,
                                            cellReuseIdentifier: cellReuseIdentifier,
                                            accountsController: accountsController)
        dataSource.actions = AccountsDataSource.Actions(deleteAccount: { [weak self] (account) in
            guard let controller = self?.accountsController else { return }
            controller.delete(account)
        })
        return dataSource
    }

    func updateUI(animated: Bool) {
        guard let controller = accountsController else { return }
        let accounts = controller.getAccounts()
        
        var snapshot = NSDiffableDataSourceSnapshot<AccountsDataSource.Section, AccountDTO>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(accounts, toSection: .main)
      
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension AccountsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let account = dataSource.itemIdentifier(for: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.accountsViewController(self, didSelectAccount: account)
    }
}
