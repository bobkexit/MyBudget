//
//  UITableViewCell+Ext.swift
//  My budget
//
//  Created by Nikolay Matorin on 27.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func setSelectionColor(_ color: UIColor = UIColor.actionColor.withAlphaComponent(0.5)) {
        let view = UIView()
        view.backgroundColor = color
        self.selectedBackgroundView = view
    }
}

extension UITableView {
    var emptySpaceHeight: CGFloat? {
        guard let indexPath = self.indexPathsForVisibleRows?.last else { return nil }
        let lastRowFrame = rectForRow(at: indexPath)
        let emptySpaceHeight = frame.size.height - (lastRowFrame.origin.y + lastRowFrame.size.height)
        return emptySpaceHeight
    }
}
