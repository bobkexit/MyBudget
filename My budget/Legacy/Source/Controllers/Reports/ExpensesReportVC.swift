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
                
                if let category = result["category"] as? String, let amount = result["totalAmount"] as? NSNumber {
                                       
                    let entry = PieChartDataEntry(value: fabs(amount.doubleValue), label: Helper.shared.trancate(Phrase: category))
                    
                    chartDataEntry.append(entry)
                }
            }
            
            if chartDataEntry.count == Constants.Reports.countCategoriesToShow {
                let minEntry = chartDataEntry.min {a, b in a.value < b.value}
                minEntry?.label = NSLocalizedString("etc.", comment: "")
            }
           
            let dataSet = PieChartDataSet(entries: chartDataEntry, label: nil)
            dataSet.colors = ChartColorTemplates.colorful()
            dataSet.valueColors = [UIColor.white]
            dataSet.sliceSpace = 2.0
            dataSet.xValuePosition = UIDevice.current.orientation.isLandscape ? .outsideSlice : .insideSlice
            
            
            let formatter = PercentageValueFormatter()
    
            let data = PieChartData(dataSet: dataSet)
            self.pieChart.data = data
            self.pieChart.data?.setValueFormatter(formatter)
            
            self.pieChart.animate(yAxisDuration: 1.5)
            
            //This must stay at end of function
            self.pieChart.notifyDataSetChanged()
        }
    }
    
    func pieChartSetup() {
        
        self.pieChart.legend.textColor = UIColor.gray
        self.pieChart.usePercentValuesEnabled = true
        self.pieChart.chartDescription = nil
        self.pieChart.holeColor = .clear
        
        if UIDevice.current.orientation.isPortrait {
          
            let attributes = [ NSAttributedString.Key.foregroundColor : UIColor.white,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
            
            self.pieChart.centerAttributedText = NSAttributedString(string: NSLocalizedString("Expenses", comment: ""), attributes: attributes)
        } else {
            self.pieChart.centerAttributedText = nil
        }
        
        self.pieChart.holeRadiusPercent = 0.3
        self.pieChart.transparentCircleRadiusPercent = 0.4
        self.pieChart.legend.wordWrapEnabled = true
        //self.pieChart.drawEntryLabelsEnabled = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        pieChartSetup()
        pieChartUpdate()
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
