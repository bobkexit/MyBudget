//
//  ExpensesReportVC.swift
//  My budget
//
//  Created by Николай Маторин on 26.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import Charts

class ExpensesReportVC: BaseReportVC {

    @IBOutlet weak var pieChart: PieChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = report.description
        
        pieChartSetup()
        pieChartUpdate()
    }
    
    func pieChartUpdate () {
        report.execute { (results) in
            
            guard let results = results else {
                return
            }
            
            var chartDataEntry = [PieChartDataEntry]()
            
            for rawResult in results {
                guard let result = rawResult as? [String: AnyObject] else {
                    return
                }
                
                let category = result["category"] as! String
                let amount = result["totalAmount"] as! Double
               
                let entry = PieChartDataEntry(value: fabs(amount), label: category)
                
                chartDataEntry.append(entry)
            }
            
            let dataSet = PieChartDataSet(values: chartDataEntry, label: nil)
            dataSet.colors = ChartColorTemplates.joyful()
            dataSet.valueColors = [UIColor.black]
            
            let data = PieChartData(dataSet: dataSet)
            self.pieChart.data = data
            
            //This must stay at end of function
            self.pieChart.notifyDataSetChanged()
        }
    }
    
    func pieChartSetup() {
        self.pieChart.legend.textColor = UIColor.gray
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
