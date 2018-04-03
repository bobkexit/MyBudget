//
//  AddAccountVC.swift
//  My budget
//
//  Created by Николай Маторин on 22.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

protocol AddAccountVCDelegate {
    func newAccountHasBeenCreated()
}

class AddAccountVC: BaseVC {

    // MARK: - IBOutlets
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var accountTypeTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var balanceTextField: UITextField!
    
    
    // MARK: - Constants
    
    fileprivate let toolBarForPicker = UIToolbar()
    fileprivate let accountTypePicker = UIPickerView()
    fileprivate let currencyPicker = UIPickerView()
    
    fileprivate let currencies = Helper.shared.getCurrencies()
    fileprivate let accountTypes = Array(RealmAccount.AccountType.cases())
    
    
    // MARK: - Properties
    
    fileprivate var selectedAccountType: RealmAccount.AccountType?
    fileprivate var selectedCurrency: String?
    
    var delagate: AddAccountVCDelegate?
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedCurrency = Locale.current.currencyCode
        if let currencyCode = selectedCurrency {
            currencyTextField.text = Locale.current.localizedString(forCurrencyCode: currencyCode)
            guard let index = currencies.index(of: currencyCode) else {
                return
            }
            currencyPicker.selectRow(index, inComponent: 0, animated: true)
        }
    }

   
    // MARK: - View Actions
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
        if !isValidData() {
            return
        }
        
        let accountName = titleTextField.text!.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
        let account = RealmAccount(name: accountName, accountType: selectedAccountType!, currencyCode: selectedCurrency!)
        DataManager.shared.createOrUpdate(data: account)
        NotificationCenter.default.post(name: .account, object: nil)
        //delagate?.newAccountHasBeenCreated()
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - View Methods

    override func setupUI() {
        setupToolbar(toolBarForPicker, withSelector: #selector(dismissKeyboard))
        
        setupPickerView(currencyPicker, delegate: self)
        setupPickerView(accountTypePicker, delegate: self)
        
        setupTextField(currencyTextField, withInputView: currencyPicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(accountTypeTextField, withInputView: accountTypePicker, andInputAccessoryView: toolBarForPicker)
        
        setBlurEffect()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func setupTextField(_ textField: UITextField, withInputView inputView: UIView?, andInputAccessoryView inputAccessoryView: UIView?) {
        super.setupTextField(textField, withInputView: inputView, andInputAccessoryView: inputAccessoryView)
        textField.delegate = self
    }
    
    fileprivate func setBlurEffect() {
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.insertSubview(blurEffectView, at: 0)
        } else {
            view.backgroundColor = .black
        }
    }
    
    fileprivate func isValidData() -> Bool {
        var isValid = true
        var invalidFields = [UITextField]()
        
        let emptyTitle = titleTextField.text?.isEmpty ?? true
        
        if emptyTitle   {
            invalidFields.append(titleTextField)
            isValid = false
        }
        
        if selectedCurrency == nil  {
            invalidFields.append(currencyTextField)
            isValid = false
        }
        
        if selectedAccountType == nil  {
            invalidFields.append(accountTypeTextField)
            isValid = false
        }
        
        invalidFields.forEach { textfield in
            UIView.animate(withDuration: 1, animations: {
                textfield.backgroundColor = Constants.Colors.error
            })
        }
        
        return isValid
    }
}


// MARK: UIPickerViewDelegate and UIPickerViewDataSource Methods

extension AddAccountVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == accountTypePicker {
            return accountTypes.count
        } else if pickerView == currencyPicker {
            return currencies.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == accountTypePicker {
            return accountTypes[row].description
        } else if pickerView == currencyPicker {
            return Locale.current.localizedString(forCurrencyCode: currencies[row]) //currencies[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == accountTypePicker {
            selectedAccountType = accountTypes[row]
            accountTypeTextField.text = selectedAccountType?.description
        } else if pickerView == currencyPicker {
            selectedCurrency = currencies[row]
            currencyTextField.text = Locale.current.localizedString(forCurrencyCode: currencies[row])
        }
    }
}

extension AddAccountVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let pickerView = textField.inputView as? UIPickerView, pickerView.numberOfRows(inComponent: 0) > 0 else {
            return
        }
        let row = pickerView.selectedRow(inComponent: 0)
        self.pickerView(pickerView, didSelectRow: row, inComponent: 0)
    }
}

