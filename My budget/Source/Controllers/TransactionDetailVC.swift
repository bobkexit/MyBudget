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
    
    // MARK: - Constants
    fileprivate let toolBarForPicker = UIToolbar()
    fileprivate let datePicker = UIDatePicker()
    fileprivate let accountPicker = UIPickerView()
    fileprivate let categoryPicker = UIPickerView()
    
    fileprivate let accounts = DataManager.shared.getData(of: RealmAccount.self)
    fileprivate var categories: Results<RealmCategory>!
    
    
    // MARK: - Properties
    
    var transaction: RealmTransaction?
    fileprivate var selectedAccount: RealmAccount?
    fileprivate var selectedCategory: RealmCategory?
    fileprivate var selectedCategoryType = CategoryType.credit
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        reloadData()
    }
    
    
    // MARK: - View Actions
    
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
    
    @objc func datePickerValueChannged(_ sender: Any) {
        let dateFormatter = Helper.shared.getDateFormatter()
        dateTxt.text = dateFormatter.string(from: datePicker.date)
    }
    
    // MARK: - View Methods
    
    override func setupUI() {
        setupToolbar(toolBarForPicker, withSelector: #selector(dismissKeyboard))
        
        setupPickerView(accountPicker, delegate: self)
        setupPickerView(categoryPicker, delegate: self)
        setupDatePickerView(datePicker)
        
        setupTextField(accountTxt, withInputView: accountPicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(categoryTxt, withInputView: categoryPicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(dateTxt, withInputView: datePicker, andInputAccessoryView: toolBarForPicker)
        
        amountTxt.delegate = self
        amountTxt.inputAccessoryView = toolBarForPicker
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    fileprivate func setupDatePickerView(_ datePickerView: UIDatePicker) {
        datePicker.addTarget(self, action: #selector(datePickerValueChannged(_:)), for: .valueChanged)
        datePicker.timeZone = TimeZone.current
    }
    
    fileprivate func updateUI() {
        let dateFormatter = Helper.shared.getDateFormatter()
        
        if let transaction = transaction {
            dateTxt.text = dateFormatter.string(from: transaction.date)
            accountTxt.text = transaction.account?.name
            categoryTxt.text = transaction.category?.name
            amountTxt.text = transaction.sum != 0 ? String(format: "%.2f", transaction.sum) : ""
            updateAmountText()
        } else {
            dateTxt.text = dateFormatter.string(from: Date())
        }
        
        if selectedCategoryType == .credit {
            segmentedControl.selectedSegmentIndex = 0
        } else if selectedCategoryType == .debit {
            segmentedControl.selectedSegmentIndex = 1
        }
        
    }
    
    fileprivate func updateAmountText() {
        if !(amountTxt.text?.isEmpty ?? true) && selectedAccount != nil {
            amountTxt.text = amountTxt.text! + " \(selectedAccount?.currency?.symbol ?? "")"
        }
    }
    
    // MARK: - Data Methods
    fileprivate func reloadData() {
        categories = DataManager.shared.getData(of: RealmCategory.self).filter("categoryTypeId = \(selectedCategoryType.rawValue)")
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
            updateAmountText()
        } else if pickerView == categoryPicker {
            selectedCategory = categories[row]
            categoryTxt.text = selectedCategory?.name
        }
    }
    
}

extension TransactionDetailVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountTxt {
            updateAmountText()
        }
    }
}

