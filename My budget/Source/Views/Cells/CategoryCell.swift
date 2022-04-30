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
    
    var categoryViewModel: CategoryVM!
    
    override func configureCell(viewModel: SomeViewModel) {
        guard let viewModel = viewModel as? CategoryVM else { return }
        self.categoryViewModel = viewModel
        
        categoryName.delegate = self
        categoryName.contentVerticalAlignment = .center
        categoryName.text = categoryViewModel.title
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
        textField.text = textField.text?.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
        delegate?.cellDidEndEditing(editingCell: self)
    }
}
