//
//  CreateExpenseVC.swift
//  My budget
//
//  Created by Николай Маторин on 23.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class CreateTransactionVC: BaseTransactionVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dateTxt: UITextField!
    
    @IBOutlet weak var accountTxt: UITextField!
    
    @IBOutlet weak var categoryTxt: UITextField!
    
    @IBOutlet weak var amountTxt: UITextField!
    
    @IBOutlet weak var commentTxtView: UITextView!
    
    @IBOutlet weak var scanQRCodeBtn: UIButton!
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    override func setupUI() {
        super.setupUI()
        
        datePicker.addTarget(self, action: #selector(datePickerValueChannged(_:)), for: .valueChanged)
        
        setupTextField(accountTxt, withInputView: accountPicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(categoryTxt, withInputView: categoryPicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(dateTxt, withInputView: datePicker, andInputAccessoryView: toolBarForPicker)
        setupTextField(amountTxt, withInputView: nil, andInputAccessoryView: toolBarForPicker)
        
        commentTxtView.delegate = self
        
        scanQRCodeBtn.isHidden = viewModel?.operationType != .credit
    }
    
    override func updateUI() {
        super.updateUI()
        
        dateTxt.text = viewModel?.date
        accountTxt.text = viewModel?.account
        categoryTxt.text = viewModel?.category
        amountTxt.text = viewModel?.amountAbs
    }
    
    // MARK: - View Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if let date = dateTxt.text, date != viewModel?.date {
            viewModel?.set(date, forKey: "date")
        }
        
        viewModel?.save()
        
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scanQRCodeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.toQRScannerVC, sender: self)
    }
    
    @objc func datePickerValueChannged(_ sender: Any) {
        viewModel?.set(datePicker.date, forKey: "date")
        updateUI()
    }
    
    // MARK: - View Methods
    
    override func setupViewTitle() {
        switch viewModel?.operationType {
        case .debit:
            title = Localization.newIncome
        case .credit:
            title = Localization.newExpense
        default:
            break
        }
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
        updateUI()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.toQRScannerVC {
            guard let destinationVC = segue.destination as? QRScannerVC  else { return }
            destinationVC.delegate = self
        }
    }
}

extension CreateTransactionVC {
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
}

extension CreateTransactionVC: UITextViewDelegate {
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

extension CreateTransactionVC: QRScannerVCDelegate {
    func qrScanner(found code: String) {
        QRCodeParser.shared.parse(code: code) { (date, sum) in
            if let date = date {
                viewModel?.set(date, forKey: "date")
            }
            
            if let amount = sum {
                viewModel?.set(amount, forKey: "amount")
            }
            updateUI()
        }
    }
}
