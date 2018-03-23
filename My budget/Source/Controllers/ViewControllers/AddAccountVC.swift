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

class AddAccountVC: UIViewController {

    @IBOutlet weak var roundedView: RoundedView!
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var accountTypeTextField: CustomTextField!
    @IBOutlet weak var currencyTextField: CustomTextField!
    @IBOutlet weak var balanceTextField: CustomTextField!
    
    fileprivate let accountTypePicker = UIPickerView()
    fileprivate let currencyPicker = UIPickerView()
    
    fileprivate let currencyRepository = RealmRepository<RealmCurrency>()
    fileprivate let accountRepository = RealmRepository<RealmAccount>()
    
    fileprivate var currencies: [RealmCurrency]!
    fileprivate var accountTypes: [RealmAccount.AccountType]!
    
    fileprivate var selectedAccountType: RealmAccount.AccountType?
    fileprivate var selectedCurrency: RealmCurrency?
    
    var delagate: AddAccountVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        currencies = currencyRepository.getAll()
        accountTypes = Array(RealmAccount.AccountType.cases())
    }

    func setup() {
        setBlurEffect()
        setupCurrencyPicker()
        setupAccountTypePicker()
        createToolbar()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        if !isValidData() {
            return
        }
        
        let newAccount = RealmAccount(name: titleTextField.text!, accountType: selectedAccountType!, currency: selectedCurrency!)
        accountRepository.insert(item: newAccount) { (error) in
            self.delagate?.newAccountHasBeenCreated()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func isValidData() -> Bool {
        guard let accountTitle = titleTextField.text, !accountTitle.isEmpty else {
            return false
        }
        
        guard let _ = selectedCurrency else {
            return false
        }
        
        guard let _ = selectedAccountType else {
            return false
        }
        
        return true
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        toolBar.barTintColor = .clear
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        accountTypeTextField.inputAccessoryView = toolBar
        currencyTextField.inputAccessoryView = toolBar
    }
    
    func setupAccountTypePicker() {
        accountTypePicker.delegate = self
        accountTypePicker.dataSource = self
        
        accountTypeTextField.inputView = accountTypePicker
    }
    
    func setupCurrencyPicker() {
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        currencyTextField.inputView = currencyPicker
    }
    
    func setBlurEffect() {
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.insertSubview(blurEffectView, at: 0)
        } else {
            view.backgroundColor = .black
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

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
            return currencies[row].code
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == accountTypePicker {
            selectedAccountType = accountTypes[row]
            accountTypeTextField.text = selectedAccountType?.description.capitalized
        } else if pickerView == currencyPicker {
            selectedCurrency = currencies[row]
            currencyTextField.text = selectedCurrency?.code
        }
    }
}
