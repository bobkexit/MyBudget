//
//  CreateAccountVC.swift
//  My budget
//
//  Created by Николай Маторин on 16.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class CreateAccountVC: BaseVC {
    
    typealias Entity = Account
    
    typealias ViewModel = AccountVM
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTxtField: UITextField!
    
    @IBOutlet weak var accountTypeTxtField: UITextField!
    
    @IBOutlet weak var balanceTxtField: UITextField!
    
    private let toolBar = UIToolbar()
    private let accountTypePicker = UIPickerView()
    
    // MARK: - Properties
    
    var viewModel: ViewModel?
    
    private let accountTypes = AccountType.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func setupUI() {
        setupToolbar(toolBar, withSelector: #selector(BaseVC.dismissKeyboard))
        setupPickerView(accountTypePicker, delegate: self)
        setupTextField(accountTypeTxtField, withInputView: accountTypePicker, andInputAccessoryView: toolBar)
        setupTextField(balanceTxtField, withInputView: nil, andInputAccessoryView: toolBar)
        
        titleTxtField.delegate = self
        balanceTxtField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc override func updateUI() {
        titleTxtField.text = viewModel?.title
        accountTypeTxtField.text = viewModel?.accountType?.description
        
        if let accountType = viewModel?.accountType, let row = accountTypes.firstIndex(of: accountType) {
             accountTypePicker.selectRow(row, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        if !validateForm() {
            return
        }
        
        dismissKeyboard()
        
        viewModel?.save()
        
        NotificationCenter.default.post(name: .account, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == accountTypePicker {
            return accountTypes.count
        }
        return 0
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == accountTypePicker {
            let accountType = accountTypes[row]
            return accountType.description
        }
        return nil
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == accountTypePicker {
            let accountType = accountTypes[row]
            viewModel?.set(accountType, forKey: "accountType")
        }
        updateUI()
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.capitalized
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textField == titleTxtField {
            guard let title = textField.text,!title.isEmpty else {
                return
            }
            viewModel?.set(title, forKey: "title")
        } else if textField == balanceTxtField {
            guard let balance = textField.text,!balance.isEmpty else {
                return
            }
            viewModel?.set(balance, forKey: "balance")
        }
        updateUI()
    }
    
    private func validateForm() -> Bool {
        if viewModel?.title?.isEmpty == true {
            UIView.animate(withDuration: 1) { [weak self] in
                self?.titleTxtField.backgroundColor = Constants.DefaultColors.red
            }
            return false
        }
        return true
    }
}
