//
//  BalanceReportVC.swift
//  My budget
//
//  Created by Николай Маторин on 27.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import Charts

class BalanceReportVC: BaseReportVC {
    
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var accounts = [SomeViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        loadData()
    }
    
    fileprivate func loadData() {
        
        self.report.execute { (results) in
            
            guard let result = results?.first as? [String : Any] else {
                return
            }
            
            if let total = result["total"] as? Float {
                
                if let currencyFormatter = Helper.shared.createFormatter(for: .currency) as? NumberFormatter {
                    
                    let value = NSNumber(value: total)
                    self.totalAmountLbl.text = currencyFormatter.string(from: value)
                }
                
                self.totalAmountLbl.textColor = total < 0 ? Constants.DefaultColors.red : Constants.DefaultColors.green
            }
            
            if let accounts = result["accounts"] as? [SomeViewModel] {
                self.accounts = accounts
            }
            
        }
    }
}


extension BalanceReportVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.accountBalanceCell, for: indexPath) as? AccountBalanceCell else { return UITableViewCell() }
        
        let accountBalanceVM = accounts[indexPath.row]
        cell.configureCell(viewModel: accountBalanceVM)
        
        return cell
    }
}

extension BalanceReportVC: UITableViewDelegate {
    
}
