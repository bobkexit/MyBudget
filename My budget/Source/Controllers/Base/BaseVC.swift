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
    
    func setupUI() { }
    
    func updateUI() { }
    
    func setupPickerView<T: UIPickerViewDataSource & UIPickerViewDelegate>(_ pickerView: UIPickerView, delegate: T) {
        pickerView.delegate = delegate
        pickerView.dataSource = delegate
    }
    
    func setupTextField(
        _ textField: UITextField,
        withInputView inputView: UIView?,
        andInputAccessoryView inputAccessoryView: UIView?
    ) {
        textField.inputView = inputView
        textField.inputAccessoryView = inputAccessoryView
    }
    
    func setupToolbar(_ toolBar: UIToolbar, withSelector selector: Selector?) {
        toolBar.sizeToFit()
        
        toolBar.barTintColor = .clear
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: Localization.done, style: .done, target: self, action: selector)
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension BaseVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { 0 }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { nil }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { }
}

extension BaseVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let pickerView = textField.inputView as? UIPickerView, pickerView.numberOfRows(inComponent: 0) > 0 else {
            return
        }
        let row = pickerView.selectedRow(inComponent: 0)
        self.pickerView(pickerView, didSelectRow: row, inComponent: 0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

