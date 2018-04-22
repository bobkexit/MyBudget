//
//  TransactionDetailVC.swift
//  My budget
//
//  Created by Николай Маторин on 27.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionDetailVC: BaseVC {
    
    typealias Entity = Transaction
    typealias ViewModel = TransactionVM
  
    // MARK: - IBOutlets
    
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var accountTxt: UITextField!
    @IBOutlet weak var categoryTxt: UITextField!
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var commentTxtView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var scanQRCodeBtn: UIButton!
    
    // MARK: - Constants
    fileprivate let toolBarForPicker = UIToolbar()
    fileprivate let datePicker = UIDatePicker()
    fileprivate let accountPicker = UIPickerView()
    fileprivate let categoryPicker = UIPickerView()
    
    var accounts = [Account]()
    var categories = [Category]()
    
    
    // MARK: - Properties    
    var viewModel: ViewModel!
    
    let accountManager = BaseDataManager<Account>()
    var categoryManager: BaseDataManager<Category>?
    
    var selectedAccount: Account?
    var selectedCategory: Category?
    
    fileprivate var selectedDate: Date?
    //fileprivate var operationType: CategoryType = .credit
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        reloadData()
        updateUI()
    }
    
    
    // MARK: - View Actions
    
    //TODO: - needs to refactoring
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        //FIXME: - don't work animation invalid fields
        if !validateData() {
            return
        }
        
        if let date = dateTxt.text, date != viewModel.date {
            viewModel.set(date: date)
        }
        
        viewModel.save()
        
        NotificationCenter.default.post(name: .transaction, object: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.operationType = .credit
        case 1:
            viewModel.operationType = .debit
        default:
            return
        }
            
        reloadData()
        updateUI()
    }
    
    @available(iOS 10.2, *)
    @IBAction func scanQRCodeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.toQRScannerVC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.toQRScannerVC {
            if #available(iOS 10.2, *) {
                guard let destinationVC = segue.destination as? QRScannerVC  else { return }
                destinationVC.delegate = self
            } else {
                // Fallback on earlier versions
            }
        }
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
        
        commentTxtView.delegate = self
        
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
    
    override func updateUI() {
        
        dateTxt.text = viewModel.date
        accountTxt.text = viewModel.account
        
        if let row = accounts.index(where: { $0.objectID.uriRepresentation() == viewModel.accountID }) {
            accountPicker.selectRow(row, inComponent: 0, animated: true)
        }
    
        categoryTxt.text = viewModel.category
        
        if let row = categories.index(where: { $0.objectID.uriRepresentation() == viewModel.categoryId }) {
            categoryPicker.selectRow(row, inComponent: 0, animated: true)
        }
        
        amountTxt.text = viewModel.amount
        
        if viewModel.operationType == .credit {
            segmentedControl.selectedSegmentIndex = 0
        } else {
            segmentedControl.selectedSegmentIndex = 1
        }
    }
    
    // MARK: - Data Methods
    fileprivate func reloadData() {
        
        if viewModel.operationType == .credit {
            categoryManager = ExpenseCategoryManager()
        } else if viewModel.operationType == .debit {
            categoryManager = IncomeCategoryManager()
        }

        accounts = accountManager.getObjects()
        categories = categoryManager!.getObjects()
        
        if selectedAccount == nil {
            selectedAccount = accounts.first
        }
        
        if selectedCategory == nil {
            selectedCategory = UserSettings.defaults.defaultCategory(forCategoryType: viewModel.operationType)
        }
    }
    
    // FIXME: - DRY
    fileprivate func validateData() -> Bool {
        var isValid = true
        var invalidFields = [UITextField]()
        
        if viewModel.account == nil {
            isValid = false
            invalidFields.append(accountTxt)
        }
        
        if viewModel.category == nil {
            isValid = false
            invalidFields.append(categoryTxt)
        }
        
        if viewModel.amount?.isEmpty ?? true {
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
}


// MARK: - UIPickerViewDelegate, UIPickerViewDataSource Methods

extension TransactionDetailVC  {
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == accountPicker {
            return accounts.count
        } else if pickerView == categoryPicker {
            return categories.count
        }
        
        return 0
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == accountPicker {
            return accounts[row].title
        } else if pickerView == categoryPicker {
            return categories[row].title
        }
        
        return nil
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == accountPicker {
            selectedAccount = accounts[row]
            viewModel.set(account: selectedAccount!)
        } else if pickerView == categoryPicker {
            selectedCategory = categories[row]
            viewModel.set(category: selectedCategory!)
        }
        updateUI()
    }
    
}

// MARK: - UITextFieldDelegate Methods

extension TransactionDetailVC {
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
            viewModel.set(comment: textView.text)
        }
        updateUI()
    }
}

extension TransactionDetailVC: QRScannerVCDelegate {
    func qrScanner(found code: String) {
        QRCodeParser.shared.parse(code: code) { (date, sum) in
            if let date = date {
                viewModel.set(date: date)
            }
            
            if let amount = sum {
                viewModel.set(amount: amount)
            }
            updateUI()
        }
    }
}
