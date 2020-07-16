//
//  BaseCell.swift
//  My budget
//
//  Created by Николай Маторин on 20.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

protocol UITableViewCellDelgate {
    func cellDidBeginEditing(editingCell: UITableViewCell)
    func cellDidEndEditing(editingCell: UITableViewCell)
}

extension UITableViewCellDelgate {
    func cellDidBeginEditing(editingCell: UITableViewCell) {
        
    }
    
    func cellDidEndEditing(editingCell: UITableViewCell) {
        
    }
}

class BaseCell: UITableViewCell {
    var delegate: UITableViewCellDelgate?
    
    func configureCell(viewModel: SomeViewModel) {
        
    }
}
