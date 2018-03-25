//
//  BaseCell.swift
//  My budget
//
//  Created by Николай Маторин on 20.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import RealmSwift

protocol UITableViewCellDelgate {
    func cellDidBeginEditing(editingCell: CategoryCell)
    func cellDidEndEditing(editingCell: CategoryCell)
}

class BaseCell: UITableViewCell {
    
    var delegate: UITableViewCellDelgate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        self.accessoryType = .none
        self.textLabel?.textColor = UIColor.white
    }
}
