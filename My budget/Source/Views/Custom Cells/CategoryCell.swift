//
//  CategoryCell.swift
//  My budget
//
//  Created by Николай Маторин on 20.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class CategoryCell: BaseCell {
    
    @IBOutlet weak var categoryName: UITextField!
    
    var category: RealmCategory!
    
    func configureCell(_ data: RealmCategory) {
        setup()
        self.category = data
        self.categoryName.text = data.name
    }
    
    fileprivate func setup() {
        categoryName.delegate = self
        categoryName.contentVerticalAlignment = .center
    }
}

// MARK: - UITextFieldDelegate methods
extension CategoryCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // close the keyboard on Enter
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         delegate?.cellDidBeginEditing(editingCell: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.cellDidEndEditing(editingCell: self)
    }
}
