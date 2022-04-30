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
        report.execute { [weak self] results in
            
            guard let strongSelf = self, let results = results else {
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
            strongSelf.pieChart.data = data
            strongSelf.pieChart.data?.setValueFormatter(formatter)
            
            strongSelf.pieChart.animate(yAxisDuration: 1.5)
            
            //This must stay at end of function
            strongSelf.pieChart.notifyDataSetChanged()
        }
    }
    
    func pieChartSetup() {
        
        pieChart.legend.textColor = .gray
        pieChart.usePercentValuesEnabled = true
        pieChart.chartDescription = nil
        pieChart.holeColor = .clear
        
        if UIDevice.current.orientation.isPortrait {
            
            let attributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)
            ]
            
            pieChart.centerAttributedText = NSAttributedString(string: NSLocalizedString("Expenses", comment: ""), attributes: attributes)
        } else {
            pieChart.centerAttributedText = nil
        }
        
        pieChart.holeRadiusPercent = 0.3
        pieChart.transparentCircleRadiusPercent = 0.4
        pieChart.legend.wordWrapEnabled = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        pieChartSetup()
        pieChartUpdate()
    }
}
