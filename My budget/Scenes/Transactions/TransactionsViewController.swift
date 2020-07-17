//
//  TransactionsViewController.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width:  tableView.frame.size.width, height: 60.0)))
       // tableView.separatorColor = .clear
        return tableView
    } ()
    
    private lazy var addTransactionButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 40.0, height: 40.0)))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.plus, for: .normal)
        button.backgroundColor = .orangePeel
        button.tintColor = .richBlackForga30
        button.addTarget(self, action: #selector(addTransactionButtonTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = button.bounds.height / 2
        return button
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Transactions"
        view.backgroundColor = .richBlackForga30
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .sliderHorizontal,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(filterButtonTapped(_:)))
        setupUI()
    }
    
    @objc private func addTransactionButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc private func filterButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(addTransactionButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addTransactionButton.heightAnchor.constraint(equalToConstant: 40.0),
            addTransactionButton.widthAnchor.constraint(equalTo: addTransactionButton.heightAnchor),
            addTransactionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addTransactionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

extension TransactionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseIdentifier) as! TransactionCell
        cell.mockup()
        return cell
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
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.babyPowder.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        label.text = "Today"
        return label
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
