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
    typealias ViewModel = AccountViewModel
    typealias AccountType = BaseViewModel.AccountType
    
    @IBOutlet weak var titleTxtField: UITextField!
    
    @IBOutlet weak var accountTypeTxtField: UITextField!
    
    @IBOutlet weak var balanceTxtField: UITextField!
    
    fileprivate let toolBar = UIToolbar()
    fileprivate let accountTypePicker = UIPickerView()
    
    var viewModel: ViewModel!
    
    fileprivate let accountTypes = Array(AccountType.cases())
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func setupUI() {
        setupToolbar(toolBar, withSelector: #selector(BaseVC.dismissKeyboard))
        setupPickerView(accountTypePicker, delegate: self)
        setupTextField(accountTypeTxtField, withInputView: accountTypePicker, andInputAccessoryView: toolBar)
        titleTxtField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func updateUI() {
        titleTxtField.text = viewModel.title
        accountTypeTxtField.text = viewModel.accountType.description
        
        if let row = accountTypes.index(of: viewModel.accountType) {
             accountTypePicker.selectRow(row, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        if !validateForm() { return }
        
        viewModel.save()
        NotificationCenter.default.post(name: .account, object: nil)
        
        if let balance = balanceTxtField.text {
            viewModel.set(balance: balance)
        }
        
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
            viewModel.set(accountType: accountType)
        }
        updateUI()
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.capitalized
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if textField == titleTxtField {
            guard let title = textField.text, title.isEmpty else { return }
            viewModel.set(title: title)
        }
        updateUI()
    }
    
    fileprivate func validateForm() -> Bool {
        if viewModel.title.isEmpty {
            UIView.animate(withDuration: 1) {
                self.titleTxtField.backgroundColor = Constants.Colors.credit
            }
            return false
        }
        return true
    }
    
}
