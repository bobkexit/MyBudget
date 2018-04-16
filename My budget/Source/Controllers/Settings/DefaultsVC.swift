//
//  DefaultsVC.swift
//  My budget
//
//  Created by Николай Маторин on 16.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class DefaultsVC: BaseVC {

    // MARK: - Type Alias
    typealias CategoryType = BaseViewModel.CategoryType
    
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
    
    var dataManager = DataManager.shared
    
    var userSettings = UserSettings.defaults
    
    let currencies = Locale.commonISOCurrencyCodes
    
    var accounts: [[String: String]] = []
    
    var expenses: [[String: String]] = []
    
    var incomes: [[String: String]] = []
    
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: Overridden Base Class Methods
    override func setupUI() {
        
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
            
            if let row = accounts.index(of: ["id": account.id, "title": account.title]) {
                accountPicker.selectRow(row, inComponent: 0, animated: true)
            }
        }
        
        if let expenseCategory = userSettings.expenseCategory {
            
            expenseTxtField.text = expenseCategory.title
            
            if let row = expenses.index(of: ["id": expenseCategory.id, "title": expenseCategory.title]) {
                expensePicker.selectRow(row, inComponent: 0, animated: true)
            }
        }
        
        
        if let incomeCategory = userSettings.incomeCategory {
         
            incomeTxtField.text = incomeCategory.title
            
            if let row = incomes.index(of: ["id": incomeCategory.id, "title": incomeCategory.title]) {
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
        var viewModel: [String: String]?
        
        if pickerView == currencyPicker {
            title = currencies[row]
        } else {
            
            if pickerView == accountPicker {
                viewModel = accounts[row]
            } else if pickerView == expensePicker {
                viewModel = expenses[row]
            } else if pickerView == incomePicker {
                viewModel = incomes[row]
            }
            
            title = viewModel?["title"]
        }
        
        return title
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == currencyPicker {
            
            let currencyCode = currencies[row]
            
            userSettings.setDefault(currencyCode: currencyCode)
            
        } else if pickerView == accountPicker, let accountId = accounts[row]["id"] {

            userSettings.setDefault(accountId: accountId)
        
        } else if pickerView == expensePicker, let categoryId = expenses[row]["id"] {
        
            userSettings.setDefault(expenseCategory: categoryId)
        
        } else if pickerView == incomePicker, let categoryId = incomes[row]["id"] {
        
            userSettings.setDefault(incomeCategory: categoryId)
       
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
        loadAccounts()
        loadExpenses()
        loadIncomes()
    }
    
    fileprivate func loadAccounts() {
      
        let data = dataManager.fetchObjects(ofType: Account.self)
        
        let _ = data.map {
            
            let account = ["id": $0.id, "title": $0.title]
            self.accounts.append(account)
            
        }
    }
    
    fileprivate func loadExpenses() {
        
        let query = "typeId = \(CategoryType.credit.rawValue)"
        let data = dataManager.fetchObjects(ofType: Category.self, filteredBy: query)
        
        let _ = data.map {
            
            let expnese = ["id": $0.id, "title": $0.title]
            self.expenses.append(expnese)
    
        }
    }
    
    fileprivate func loadIncomes() {
        
        let query = "typeId = \(CategoryType.debit.rawValue)"
        let data = dataManager.fetchObjects(ofType: Category.self, filteredBy: query)
        
        let _ = data.map {
            
            let income = ["id": $0.id, "title": $0.title]
            self.incomes.append(income)
            
        }
    }
}
