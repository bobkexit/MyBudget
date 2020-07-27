//
//  UITableViewCell+Ext.swift
//  My budget
//
//  Created by Nikolay Matorin on 27.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func selectionColor(_ color: UIColor) {
        let view = UIView()
        view.backgroundColor = color
        self.selectedBackgroundView = view
    }
}
