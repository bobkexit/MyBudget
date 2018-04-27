//
//  TransactionDetailVC.swift
//  My budget
//
//  Created by Николай Маторин on 27.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionDetailVC: BaseTransactionVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dateTxt: UITextField!
    
    @IBOutlet weak var accountTxt: UITextField!
    
    @IBOutlet weak var categoryTxt: UITextField!
    
    @IBOutlet weak var amountTxt: UITextField!
    
    @IBOutlet weak var commentTxtView: UITextView!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - View Actions
    
    @objc func datePickerValueChannged(_ sender: Any) {
        guard let dateFormatter = Helper.shared.createFormatter(for: .date) as? DateFormatter else {
            return
        }
        selectedDate = datePicker.date
        dateTxt.text = dateFormatter.string(from: selectedDate!)
    }
    
    // MARK: - View Methods
    
    override func setupUI() {
        super.setupUI()
        
        setupDatePickerView(datePicker, action: #selector(datePickerValueChannged(_:)))
        
        setupTextField(accountTxt, withInputView: accountPicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(categoryTxt, withInputView: categoryPicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(dateTxt, withInputView: datePicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(amountTxt, withInputView: nil, andInputAccessoryView: toolBarForPicker)
        
        commentTxtView.delegate = self
    }
    
    override func setupViewTitle() {
        if viewModel.operationType == .debit {
            title = "Income Trnasaction"
        } else if viewModel.operationType == .credit {
            title = "Expense Transacion"
        }
    }
    
    override func updateUI() {
        super.updateUI()

        dateTxt.text = viewModel.date
        accountTxt.text = viewModel.account
        categoryTxt.text = viewModel.category
        amountTxt.text = viewModel.amountAbs
        commentTxtView.text = viewModel.comment
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == amountTxt {
            textField.text = ""
            return
        }
        super.textFieldDidBeginEditing(textField)
    }
    
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountTxt {
            viewModel.set(amount: textField.text)
        }
        updateUI()
    }
    
    func saveChanges() {
        viewModel.save()
        let userInfo = [ "transactionId" : viewModel.id ]
        NotificationCenter.default.post(name: .transaction, object: nil, userInfo: userInfo)
    }
}

// MARK: - UITextViewDelegate Methods

extension TransactionDetailVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == commentTxtView && textView.text.lowercased() == "comment" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == commentTxtView {
            viewModel.set(textView.text, forKey: "comment")
        }
        updateUI()
    }
}
