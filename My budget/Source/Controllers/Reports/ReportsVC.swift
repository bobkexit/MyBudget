//
//  ViewController.swift
//  My budget
//
//  Created by Николай Маторин on 12.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class ReportsVC: BaseTableVC {
    
    let reportManager = ReportManager.shared
    
    var reports: [Report] = ReportManager.shared.getAvailableReports()
    
    var selectedReport: Report?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.reportCell, for: indexPath) as? ReportCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = reports[indexPath.row].description
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedReport = reports[indexPath.row]
        
        guard let identifier = reportManager.segueIdentifier(forReport: selectedReport!) else {
            return
        }
        
        performSegue(withIdentifier: identifier, sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? BaseReportVC else {
            return
        }
        
        destinationVC.report = selectedReport!
    }
}

