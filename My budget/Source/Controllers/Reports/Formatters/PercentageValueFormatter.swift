//
//  PercentageFormatter.swift
//  My budget
//
//  Created by Николай Маторин on 26.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import Charts

class PercentageValueFormatter: IValueFormatter {
 
    private let formatter = NumberFormatter()
    
    init() {
        setupFormatter()
    }
    
    private func setupFormatter() {
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        
        let number = NSNumber(value: value)
        return formatter.string(from: number) ?? ""
    }
    
    
}
