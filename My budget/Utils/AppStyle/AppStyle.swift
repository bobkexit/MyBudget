//
//  AppStyle.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

extension UIColor {
    public static let actionColor =  UIColor.systemOrange//UIColor(hex: "#FF9F1C") //orangePeel
    public static let negativeAccentColor = UIColor(hex: "#F71735")
    public static let positiveAccentColor = UIColor { traitCollection -> UIColor in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#41EAD4") : UIColor(hex: "#14B8A2")
    } //turquoise
       
    public static let primaryTextColor = UIColor(hex: "#FDFFFC") // babyPowder
    public static let secondaryTextColor = UIColor.primaryTextColor.withAlphaComponent(0.6) // babyPowder60
    public static let tertiaryTextColor = UIColor(hex: "#02223C") // oxfordBlue
    
    public static let primaryBackgroundColor = UIColor(hex: "#011627")
    public static let secondaryBackgroundColor = UIColor(hex: "#02223C")
}

extension UIImage {
    public static let rubleSign = UIImage(systemName: "rublesign.circle")
    public static let dollarSign = UIImage(systemName: "dollarsign.circle")
    public static let euroSign = UIImage(systemName: "eurosign.circle")
    public static let gearShape = UIImage(named: "gearshape.2")
    public static let chartBarDocHorizontal = UIImage(named: "chart.bar.doc.horizontal")
    public static let plus = UIImage(systemName: "plus")
    public static let sliderHorizontal = UIImage(systemName: "slider.horizontal.3")
}
