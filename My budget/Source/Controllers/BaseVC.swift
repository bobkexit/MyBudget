//
//  BaseVC.swift
//  My budget
//
//  Created by Николай Маторин on 30.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
    }
    
    func setupPickerView<T: UIPickerViewDataSource & UIPickerViewDelegate>(_ pickerView: UIPickerView, delegate: T) {
        pickerView.delegate = delegate
        pickerView.dataSource = delegate
    }
    
    func setupTextField(_ textField: UITextField, withInputView inputView: UIView, andInputAccessoryView inputAccessoryView: UIView) {
        textField.inputView = inputView
        textField.inputAccessoryView = inputAccessoryView
    }
    
    func setupToolbar(_ toolBar: UIToolbar, withSelector selector: Selector?) {
        toolBar.sizeToFit()
        
        toolBar.barTintColor = .clear
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: selector)
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
