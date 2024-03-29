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
    
    // MARK: - View Actions
    
    @objc func datePickerValueChannged(_ sender: Any) {
        viewModel?.set(datePicker.date, forKey: "date")
        updateUI()
    }
    
    // MARK: - View Methods
    
    override func setupUI() {
        super.setupUI()
        
        datePicker.addTarget(self, action: #selector(datePickerValueChannged(_:)), for: .valueChanged)
        //setupDatePickerView(datePicker, action: #selector(datePickerValueChannged(_:)))
        
        setupTextField(accountTxt, withInputView: accountPicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(categoryTxt, withInputView: categoryPicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(dateTxt, withInputView: datePicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(amountTxt, withInputView: nil, andInputAccessoryView: toolBarForPicker)
        
        commentTxtView.delegate = self
    }
    
    override func setupViewTitle() {
        title = viewModel?.operationType.title
    }
    
    override func updateUI() {
        super.updateUI()

        dateTxt.text = viewModel?.date
        accountTxt.text = viewModel?.account
        categoryTxt.text = viewModel?.category
        amountTxt.text = viewModel?.amountAbs
        commentTxtView.text = viewModel?.comment
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
            viewModel?.set(textField.text, forKey: "amount")
        }
        updateUI()
    }
    
    func saveChanges() {
        guard let viewModel = viewModel else { return }
        viewModel.save()
        let userInfo = ["transactionId" : viewModel.id]
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
            viewModel?.set(textView.text, forKey: "comment")
        }
        updateUI()
    }
}
