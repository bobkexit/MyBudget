//
//  TransactionsViewController.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    struct Actions {
        var createOperation: (() -> Void)?
        var showFilters: (() -> Void)?
        var didSelectTransaction: ((TransactionDTO) -> Void)?
    }
    
    var actions: Actions = Actions()
    
    var transactionsController: TransactionsControllerProtocol!
    
    private lazy var dataSource: TransactionsDataSource = makeDataSource()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width:  tableView.frame.size.width, height: 60.0)))
        return tableView
    } ()
    
    private lazy var addTransactionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.plus, for: .normal)
        button.backgroundColor = .actionColor
        button.tintColor = .primaryBackgroundColor
        button.addTarget(self, action: #selector(addTransactionButtonTapped(_:)), for: .touchUpInside)
        return button
    } ()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter
    } ()
    
    convenience init(transactionsController: TransactionsControllerProtocol) {
        self.init()
        self.transactionsController = transactionsController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        transactionsController?.handlers = FetchDataHandlers(
            didFetchData: { [weak self] isFirstLoading in
                self?.updateUI(animated: !isFirstLoading)
            }, didFail: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addTransactionButton.layer.cornerRadius = addTransactionButton.bounds.height / 2
    }
    
    @objc private func addTransactionButtonTapped(_ sender: UIButton) {
        actions.createOperation?()
    }
    
    @objc private func filterButtonTapped(_ sender: UIBarButtonItem) {
        actions.showFilters?()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "transactions".localizeCapitalizingFirstLetter()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .sliderHorizontal,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(filterButtonTapped(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .primaryTextColor
    }
    
    private func configureViews() {
        view.backgroundColor = .primaryBackgroundColor
        view.addSubview(tableView)
        view.addSubview(addTransactionButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addTransactionButton.heightAnchor.constraint(equalToConstant: 48.0),
            addTransactionButton.widthAnchor.constraint(equalTo: addTransactionButton.heightAnchor),
            addTransactionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addTransactionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

private extension TransactionsViewController {
    func makeDataSource() -> TransactionsDataSource {
        let dataSource = TransactionsDataSource(tableView: tableView, transactionsController: transactionsController)
        dataSource.actions = TransactionsDataSource.Actions(deleteTransaction: { [weak self] (transaction) in
            guard let controller = self?.transactionsController else { return }
            controller.delete(transaction)
        })
        return dataSource
    }
    
    func updateUI(animated: Bool) {
        guard let controller = transactionsController else { return }
        let dates = controller.getDates()
        
        var snapshot = NSDiffableDataSourceSnapshot<Date, TransactionDTO>()
        snapshot.appendSections(dates)
        
        dates.forEach {
            let transactions = controller.getTransactions(for: $0)
            snapshot.appendItems(transactions, toSection: $0)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let controller = transactionsController else { return nil }
        let label = makeSectionLabel()
        let dates = controller.getDates()
        let date = dates[section]
        label.text = dateFormatter.string(from: date)
        return label
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let transaction = dataSource.itemIdentifier(for: indexPath) else { return }
        actions.didSelectTransaction?(transaction)
    }
    
    private func makeSectionLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.primaryTextColor.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        return label
    }
}
