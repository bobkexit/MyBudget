//
//  TransactionDetailVC.swift
//  My budget
//
//  Created by Николай Маторин on 27.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import RealmSwift

class TransactionDetailVC: BaseVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var accountTxt: UITextField!
    @IBOutlet weak var categoryTxt: UITextField!
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var commentTxtView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var deleteBtn: UIButton!
    
    // MARK: - Constants
    fileprivate let toolBarForPicker = UIToolbar()
    fileprivate let datePicker = UIDatePicker()
    fileprivate let accountPicker = UIPickerView()
    fileprivate let categoryPicker = UIPickerView()
    
    fileprivate let accounts = DataManager.shared.getData(of: RealmAccount.self)
    fileprivate var categories: Results<RealmCategory>!
    
    
    // MARK: - Properties
    
    var transaction: RealmTransaction?
    fileprivate var selectedDate: Date?
    fileprivate var selectedAccount: RealmAccount?
    fileprivate var selectedCategory: RealmCategory?
    fileprivate var selectedCategoryType = CategoryType.credit
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        reloadData()
        
        if accounts.count > 0 {
            accountPicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    
    // MARK: - View Actions
    
    //TODO: - needs to refactoring
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        //FIXME: - don't work animation invalid fields
        if !validateData() { return }
        
        guard let account = selectedAccount else {
            fatalError("Can't get selected account")
        }
        
        guard let category = selectedCategory else {
            fatalError("Can't get selected category")
        }
        
        let updatedTransaction = RealmTransaction()
        updatedTransaction.account = account
        updatedTransaction.category = category
        updatedTransaction.comment = getCommet()
        updatedTransaction.sum = getAmount()
        
        if let transactionId = transaction?.transactionId {
            updatedTransaction.transactionId = transactionId
        }
        
        if let date = selectedDate {
            updatedTransaction.date = date
        }
       
        DataManager.shared.createOrUpdate(data: updatedTransaction)
        NotificationCenter.default.post(name: .transaction, object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedCategoryType = .credit
        case 1:
            selectedCategoryType = .debit
        default:
            return
        }
        selectedCategory = nil
        categoryTxt.text = nil
        reloadData()
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        
        guard let transaction = transaction else { return }
        
        DataManager.shared.remove(data: transaction)
        
        NotificationCenter.default.post(name: .transaction, object: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func datePickerValueChannged(_ sender: Any) {
        let dateFormatter = Helper.shared.getDateFormatter(timeStyle: .short)
        selectedDate = datePicker.date
        dateTxt.text = dateFormatter.string(from: selectedDate!)
    }
    
    
    // MARK: - View Methods
    
    override func setupUI() {
        setupToolbar(toolBarForPicker, withSelector: #selector(self.dismissKeyboard))
        
        setupPickerView(accountPicker, delegate: self)
        setupPickerView(categoryPicker, delegate: self)
        setupDatePickerView(datePicker)
        
        setupTextField(accountTxt, withInputView: accountPicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(categoryTxt, withInputView: categoryPicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(dateTxt, withInputView: datePicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(amountTxt, withInputView: nil, andInputAccessoryView: toolBarForPicker)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func setupTextField(_ textField: UITextField, withInputView inputView: UIView?, andInputAccessoryView inputAccessoryView: UIView?) {
        super.setupTextField(textField, withInputView: inputView, andInputAccessoryView: inputAccessoryView)
        textField.delegate = self
    }
    
    fileprivate func setupDatePickerView(_ datePickerView: UIDatePicker) {
        datePicker.addTarget(self, action: #selector(datePickerValueChannged(_:)), for: .valueChanged)
        datePicker.timeZone = TimeZone.current
    }
    
    fileprivate func updateUI() {
        let dateFormatter = Helper.shared.getDateFormatter(timeStyle: .short)
        
        if let transaction = transaction {
            dateTxt.text = dateFormatter.string(from: transaction.date)
            accountTxt.text = transaction.account?.name
            categoryTxt.text = transaction.category?.name
            formatAmount(forTextField: amountTxt)
        } else {
            dateTxt.text = dateFormatter.string(from: Date())
        }
        
        if selectedCategoryType == .credit {
            segmentedControl.selectedSegmentIndex = 0
        } else if selectedCategoryType == .debit {
            segmentedControl.selectedSegmentIndex = 1
        }
        
        deleteBtn.isHidden = transaction == nil
    }
    
    fileprivate func formatAmount(forTextField textField: UITextField) {
        guard let currencyCode = selectedAccount?.currencyCode, let text = textField.text, !text.isEmpty else {
            return
        }
        
        let formatter = NumberFormatter()
       
        guard let number = formatter.number(from: text)?.doubleValue else {
            return
        }
        
        textField.text = Helper.shared.formatCurrency(number, currencyCode: currencyCode)
    }
    
    // MARK: - Data Methods
    fileprivate func reloadData() {
        categories = DataManager.shared.getData(of: RealmCategory.self).filter("categoryTypeId = \(selectedCategoryType.rawValue)")
    }
    
    fileprivate func validateData() -> Bool {
        var isValid = true
        var invalidFields = [UITextField]()
        
        if selectedAccount == nil {
            isValid = false
            invalidFields.append(accountTxt)
        }
        
        if selectedCategory == nil {
            isValid = false
            invalidFields.append(categoryTxt)
        }
        
        if amountTxt.text?.isEmpty ?? true {
            isValid = false
            invalidFields.append(categoryTxt)
        }
        
        invalidFields.forEach({ textField in
            UIView.animate(withDuration: 0, animations: {
                textField.placeholderTextColor = .red
            })
        })
        
        return isValid
    }
    
    fileprivate func getAmount() -> Double {
        
        guard let amountStr = amountTxt.text else {
            fatalError("Can't get amount")
        }
        
        let formatter = NumberFormatter()
        if let currencyCode = selectedAccount?.currencyCode, let currencySymbol = Helper.shared.getCurrencySymbol(forCurrencyCode: currencyCode) {
            
            if amountStr.hasPrefix(currencySymbol) || amountStr.hasSuffix(currencySymbol) {
                formatter.currencySymbol = currencySymbol
                formatter.numberStyle = .currency
            }
        }
        
        guard let amount = formatter.number(from: amountStr)?.doubleValue else {
            fatalError("Can't get amount")
        }
        
        return amount * Double(selectedCategoryType.sign)
    }
        
    fileprivate func getCommet() -> String? {
        guard let comment = commentTxtView.text else {
            return nil
        }
        
        if comment.lowercased().contains("comment") || comment.isEmpty {
            return nil
        }
        
        return comment
    }
}

extension TransactionDetailVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == accountPicker {
            return accounts.count
        } else if pickerView == categoryPicker {
            return categories.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == accountPicker {
            return accounts[row].name
        } else if pickerView == categoryPicker {
            return categories[row].name
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == accountPicker {
            selectedAccount = accounts[row]
            accountTxt.text = selectedAccount?.name
            formatAmount(forTextField: amountTxt)
        } else if pickerView == categoryPicker {
            selectedCategory = categories[row]
            categoryTxt.text = selectedCategory?.name
        }
    }
    
}

extension TransactionDetailVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == amountTxt {
            textField.text = ""
            return
        }
        
        guard let pickerView = textField.inputView as? UIPickerView, pickerView.numberOfRows(inComponent: 0) > 0 else {
            return
        }
        let row = pickerView.selectedRow(inComponent: 0)
        self.pickerView(pickerView, didSelectRow: row, inComponent: 0)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountTxt {
            formatAmount(forTextField: amountTxt)
        }
    }
}

