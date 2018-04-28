//
//  DefaultsVC.swift
//  My budget
//
//  Created by Николай Маторин on 16.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class DefaultsVC: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet weak var currencyTxtField: UITextField!
    
    @IBOutlet weak var accountTxtField: UITextField!
    
    @IBOutlet weak var expenseTxtField: UITextField!
    
    @IBOutlet weak var incomeTxtField: UITextField!
    
    
    // MARK: - UI Elements
    
    let currencyPicker = UIPickerView()
    
    let accountPicker = UIPickerView()
    
    let expensePicker = UIPickerView()
    
    let incomePicker = UIPickerView()
    
    let toolBar = UIToolbar()
    
    
    // MARK: - Properties

    let userDefaults = UserDefaults.standard

    let userSettings = UserSettings.defaults
    
    let currencies: [String] = Locale.commonISOCurrencyCodes
    
    var accounts: [Account] = []
    
    var expenses: [Category] = []
    
    var incomes: [Category] = []
    
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        updateUI()
    }
    
    // MARK: Overridden Base Class Methods
    override func setupUI() {
        
        title = NSLocalizedString("defaults", comment: "")
        
        setupToolbar(toolBar, withSelector: #selector(BaseVC.dismissKeyboard))
        
        setupUIPickers()
        
        setupTextFields()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func updateUI() {
        
        if let сurrencyCode = userSettings.сurrencyCode {
            currencyTxtField.text = сurrencyCode
        }
        
        if let account = userSettings.account {
            
            accountTxtField.text = account.title
            
            if let row = accounts.index(of: account) {
                accountPicker.selectRow(row, inComponent: 0, animated: true)
            }
        }
        
        if let expenseCategory = userSettings.expenseCategory {
            
            expenseTxtField.text = expenseCategory.title
            
            if let row = expenses.index(of: expenseCategory) {
                expensePicker.selectRow(row, inComponent: 0, animated: true)
            }
        }
        
        
        if let incomeCategory = userSettings.incomeCategory {
         
            incomeTxtField.text = incomeCategory.title
            
            if let row = incomes.index(of: incomeCategory) {
                incomePicker.selectRow(row, inComponent: 0, animated: true)
            }
        }
    }
    
    
    // MARK: -  UIPickerViewDataSource
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == currencyPicker {
            return currencies.count
        } else if pickerView == accountPicker {
            return accounts.count
        } else if pickerView == expensePicker {
            return expenses.count
        } else if pickerView == incomePicker {
            return incomes.count
        }
        
        return 0
    }
    
    // MARK - UIPickerViewDelegate
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title: String?
    
        if pickerView == currencyPicker {
            title = currencies[row]
        } else {
            
            if pickerView == accountPicker {
                title = accounts[row].title
            } else if pickerView == expensePicker {
                title = expenses[row].title
            } else if pickerView == incomePicker {
                title = incomes[row].title
            }
        }
        
        return title
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == currencyPicker {
            
            let currencyCode = currencies[row]
            userSettings.set(defaultCurrencyCode: currencyCode)
            
        } else if pickerView == accountPicker {

            let account = accounts[row]
            userSettings.set(defautAccount: account)
            
        
        } else if pickerView == expensePicker {
        
            let category = expenses[row]
            userSettings.set(defaultCategory: category)
        
        } else if pickerView == incomePicker {
        
            let category = incomes[row]
            userSettings.set(defaultCategory: category)
            
        }
        
        updateUI()
    }
    
    // MARK: - Private UI Methods
    
    fileprivate func setupUIPickers() {
        setupPickerView(currencyPicker, delegate: self)
        setupPickerView(accountPicker, delegate: self)
        setupPickerView(expensePicker, delegate: self)
        setupPickerView(incomePicker, delegate: self)
    }
    
    fileprivate func setupTextFields() {
        setupTextField(currencyTxtField, withInputView: currencyPicker, andInputAccessoryView: toolBar)
        setupTextField(accountTxtField, withInputView: accountPicker, andInputAccessoryView: toolBar)
        setupTextField(expenseTxtField, withInputView: expensePicker, andInputAccessoryView: toolBar)
        setupTextField(incomeTxtField, withInputView: incomePicker, andInputAccessoryView: toolBar)
    }
    
    
    // MARK: - Data methods
    
    fileprivate func loadData() {
        
        let accountManager = BaseDataManager<Account>()
        let incomeCategoryManager = IncomeCategoryManager()
        let expenseCategoryManager = ExpenseCategoryManager()
        
        accounts = accountManager.getObjects()
        expenses = expenseCategoryManager.getObjects()
        incomes = incomeCategoryManager.getObjects()
    }
}
