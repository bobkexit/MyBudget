//
//  BaseTransactionVC.swift
//  My budget
//
//  Created by Николай Маторин on 23.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class BaseTransactionVC: BaseVC {
    
    typealias Entity = Transaction
    
    typealias ViewModel = TransactionVM

    // MARK: - UI Elements
    
    let toolBarForPicker = UIToolbar()
    
    let datePicker = UIDatePicker()
    
    let accountPicker = UIPickerView()
    
    let categoryPicker = UIPickerView()
    
    // MARK: - Properties
    
    var viewModel: ViewModel!
    
    var categoryManager: BaseDataManager<Category>!
    
    var accountManager: BaseDataManager<Account>!
    
    var accounts = [Account]()
    
    var categories = [Category]()
    
    var selectedDate: Date?
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        updateUI()
    }

    // MARK: - Base View Controller Mathods
    
    override func setupUI() {
        setupToolbar(toolBarForPicker, withSelector: #selector(self.dismissKeyboard))
        setupPickerView(accountPicker, delegate: self)
        setupPickerView(categoryPicker, delegate: self)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupViewTitle()
    }
    
    override func updateUI() {
        super.updateUI()
        
        if let row = accounts.index(where: { $0.objectID.uriRepresentation() == viewModel.accountID }) {
            accountPicker.selectRow(row, inComponent: 0, animated: true)
        }
        
        if let row = categories.index(where: { $0.objectID.uriRepresentation() == viewModel.categoryId }) {
            categoryPicker.selectRow(row, inComponent: 0, animated: true)
        }
    }
    
    override func setupTextField(_ textField: UITextField, withInputView inputView: UIView?, andInputAccessoryView inputAccessoryView: UIView?) {
        super.setupTextField(textField, withInputView: inputView, andInputAccessoryView: inputAccessoryView)
        textField.delegate = self
    }
    
    func setupDatePickerView(_ datePickerView: UIDatePicker, action: Selector ) {
        datePicker.addTarget(self, action: action, for: .valueChanged)
        datePicker.timeZone = TimeZone.current
    }
    
    func setupViewTitle() {
       
    }
    
    // MARK: - Data Methods
    public func configure(viewModel: ViewModel, categoryManager: BaseDataManager<Category>, accountManager: BaseDataManager<Account>) {
        self.viewModel = viewModel
        self.accountManager = accountManager
        self.categoryManager = categoryManager
    }
    
    func loadData() {
        accounts = accountManager.getObjects()
        categories = categoryManager.getObjects()
    }
    
    //
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == accountPicker {
            return accounts.count
        } else if pickerView == categoryPicker {
            return categories.count
        }
        
        return 0
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var titleForRow: String?
        
        if pickerView == accountPicker {
            titleForRow = accounts[row].title
        } else if pickerView == categoryPicker {
            titleForRow = categories[row].title
        }
        
        return titleForRow
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == accountPicker {
            let account = accounts[row]
            viewModel.set(account: account)
        } else if pickerView == categoryPicker {
            let category = categories[row]
            viewModel.set(category: category)
        }
        updateUI()
    }
}
