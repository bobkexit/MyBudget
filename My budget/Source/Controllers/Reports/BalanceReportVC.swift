//
//  BalanceReportVC.swift
//  My budget
//
//  Created by Николай Маторин on 27.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import Charts
import TableFlip

class BalanceReportVC: BaseReportVC {
    
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmountView: UIView!
    
    var accounts = [SomeViewModel]()
    
    private lazy var currencyFormatter = Helper.shared.createCurrencyFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        loadDataAsync()
    }
    
    private func loadData() {
        report.execute { [weak self] results in
            
            guard let strongSelf = self, let result = results?.first as? [String : Any] else {
                return
            }
            
            if let total = result["total"] as? Float {
                let value = NSNumber(value: total)
                strongSelf.totalAmountLbl.text = strongSelf.currencyFormatter.string(from: value)
                strongSelf.totalAmountLbl.textColor = total < 0 ? Constants.DefaultColors.red : Constants.DefaultColors.green
            }
            
            if let accounts = result["accounts"] as? [SomeViewModel] {
                strongSelf.accounts = accounts
            }
        
            strongSelf.tableView.reloadData()
            strongSelf.animateView()
        }
    }
    
    private func loadDataAsync() {
        DispatchQueue.main.async { [weak self] in
            self?.loadData()
        }
    }
    
    private func animateView() {
        let cellAnimation = TableViewAnimation.Cell.fade(duration: 1.3)
        tableView.animate(animation: cellAnimation)
        totalAmountView.alpha = 0
        UIView.animate(withDuration: 1.3) { [weak self] in
            self?.totalAmountView.alpha = 1
        }
    }
}


extension BalanceReportVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.CellIdentifiers.accountBalanceCell,
            for: indexPath
        ) as? AccountBalanceCell else { return UITableViewCell() }
        
        let accountBalanceVM = accounts[indexPath.row]
        cell.configureCell(viewModel: accountBalanceVM)
        
        return cell
    }
}

extension BalanceReportVC: UITableViewDelegate {
    
}
