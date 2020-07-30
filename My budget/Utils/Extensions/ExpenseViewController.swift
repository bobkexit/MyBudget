//
//  ExpenseViewController.swift
//  My budget
//
//  Created by Nikolay Matorin on 27.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

protocol ExpenseViewControllerDelegate: AnyObject {
    func expenseViewController(_ viewController: ExpenseViewController, didSelectAccount account: AccountDTO?)
    func expenseViewController(_ viewController: ExpenseViewController, didSelectCategory category: CategoryDTO?)
    func expenseViewControllerDidSaveTransaction(_ viewController: ExpenseViewController)
}

class ExpenseViewController: UIViewController {
    enum Item: Int, CaseIterable {
        case date
        case datePicker
        case account
        case category
        case amount
        case comment
    }
    
    enum CellIdentifier: String {
        case basic
        case datePicker
        case text
    }
    
    var date = Date()
    var amount: Float = 0.0
    var account: AccountDTO?
    var category: CategoryDTO?
    var comment: String?
    
    weak var delegate: ExpenseViewControllerDelegate?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter
    } ()
    
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter
    } ()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Item, Item> = makeDataSouce()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero,
                                                         size: CGSize(width: tableView.frame.size.width, height: CGFloat.infinity)))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.basic.rawValue)
        tableView.register(DatePickerCell.self, forCellReuseIdentifier: CellIdentifier.datePicker.rawValue)

        return tableView
    } ()

    private lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width/2, height: 44.0)))
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(amountDidChange(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(amountDidEndEditing(_:)), for: [.editingDidEndOnExit, .editingDidEnd])
        return textField
    } ()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.textColor = .primaryTextColor
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textColor = .orange
        textView.delegate = self
        return textView
    } ()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("save".localizeCapitalizingFirstLetter(), for: .normal)
        button.backgroundColor = .actionColor
        button.tintColor = .primaryBackgroundColor
        button.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        return button
    } ()
    
    deinit {
        print(self, #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureViews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableFooterView?.setNeedsLayout()
        tableView.tableFooterView?.layoutIfNeeded()
        saveButton.layer.cornerRadius = saveButton.bounds.height / 2
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem?.tintColor = .primaryTextColor
    }
    
    private func configureViews() {
        view.backgroundColor = .primaryBackgroundColor
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        configureTableFooterView()
    }
    
    private func configureTableFooterView() {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: 100)))
        view.addSubview(saveButton)
        let buttonWidth = UIScreen.main.nativeBounds.width * 0.45
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 48.0),
            saveButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            saveButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        tableView.tableFooterView = view
    }
    
    @objc private func saveButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func amountDidEndEditing(_ sender: UITextField) {
        reloadItem(.amount)
    }
    
    @objc private func amountDidChange(_ sender: UITextField) {
        numberFormatter.numberStyle = .decimal
        guard let text = sender.text, let value = numberFormatter.number(from: text)?.floatValue ?? Float(text) else {
            return
        }
        self.amount = value
    }
    
    private func reloadItem(_ item: Item, animated: Bool = false) {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([item])
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

private extension ExpenseViewController {
    func makeDataSouce() -> UITableViewDiffableDataSource<Item, Item> {
        return UITableViewDiffableDataSource<Item, Item>(tableView: tableView) {
            [weak self] tableView, indexPath, section -> UITableViewCell? in
            guard let self = self else { return nil }
            let cell = self.makeCell(for: section, at: indexPath, in: tableView)
            cell.setSelectionColor()
            cell.backgroundColor = .secondaryBackgroundColor
            cell.textLabel?.textColor = .primaryTextColor
            cell.tintColor = .actionColor
            return cell
        }
    }
    
    func updateUI(animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Item, Item>()
        let baseForm = Item.allCases.filter { $0 != .datePicker }
    
        snapshot.appendSections(baseForm)
        baseForm.forEach { snapshot.appendItems([$0], toSection: $0) }
    
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func makeCell(for section: Item, at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch section {
        case .date:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: CellIdentifier.basic.rawValue)
            cell.textLabel?.text = "date".localizeCapitalizingFirstLetter()
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
            return cell
        case .account:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: CellIdentifier.basic.rawValue)
            cell.textLabel?.text = "account".localizeCapitalizingFirstLetter()
            cell.detailTextLabel?.text = account?.name
            cell.accessoryType = .disclosureIndicator
            return cell
        case .category:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: CellIdentifier.basic.rawValue)
            cell.textLabel?.text = "category".localizeCapitalizingFirstLetter()
            cell.detailTextLabel?.text = category?.name
            cell.accessoryType = .disclosureIndicator
            return cell
        case .amount:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: CellIdentifier.basic.rawValue)
            cell.textLabel?.text = "amount".localizeCapitalizingFirstLetter()
            numberFormatter.numberStyle = .currency
            textField.text = numberFormatter.string(from: NSNumber(value: amount))
            textField.textColor = cell.detailTextLabel?.textColor
            cell.accessoryView = textField
            return cell
        case .comment:
            let cell = UITableViewCell(style: .default, reuseIdentifier: CellIdentifier.basic.rawValue)
            textView.removeFromSuperview()
            textView.font = cell.textLabel?.font
            textView.text = comment ?? "comment".localizeCapitalizingFirstLetter()
            textView.textColor = .secondaryTextColor
            cell.contentView.addSubview(textView)
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor),
                textView.bottomAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.bottomAnchor),
                textView.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor),
                textView.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor),
            ])
            return cell
        case .datePicker:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.datePicker.rawValue, for: indexPath) as? DatePickerCell else { return UITableViewCell() }
            cell.datePicker.date = date
            cell.delegate = self
            cell.datePicker.backgroundColor = .systemBackground
            return cell
        }
    }
    
    private func showDatePicker() {
        guard !isDatePickerVisible else { return }
        var snapshot = dataSource.snapshot()
        snapshot.insertItems([.datePicker], afterItem: .date)
        dataSource.apply(snapshot)
    }
    
    private func hideDatePicker() {
        guard isDatePickerVisible else { return }
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([.datePicker])
        dataSource.apply(snapshot)
    }
    
    var isDatePickerVisible: Bool {
        return dataSource.indexPath(for: .datePicker) != nil
    }
}

extension ExpenseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return  44.0 }
        if item == .datePicker {
            if #available(iOS 14.0, *) {
                return 372.0
            } else {
                return 216.0
            }
        } else if item == .comment {
            return UITableView.automaticDimension//60.0
        } else {
            return 44.0
        }
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch item {
        case .date:
            isDatePickerVisible ? hideDatePicker() : showDatePicker()
        case .amount:
            textField.becomeFirstResponder()
        case .account:
            delegate?.expenseViewController(self, didSelectAccount: account)
        case .category:
            delegate?.expenseViewController(self, didSelectCategory: category)
        default:
            break
        }
        
        if item != .date {
            hideDatePicker()
        }
    }
}

extension ExpenseViewController: DatePickerCellDelegate {
    func datePickerCell(_ cell: DatePickerCell, didChangeDate date: Date) {
        self.date = date
        reloadItem(.date)
    }
}

extension ExpenseViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}

extension ExpenseViewController: OperationCoordinatorDelegate {
    func operationCoordinator(_ coordinator: OperationCoordinator, didSelectAccount account: AccountDTO) {
        self.account = account
        reloadItem(.account)
    }
    
    func operationCoordinator(_ coordinator: OperationCoordinator, didSelectCategory category: CategoryDTO) {
        self.category = category
        reloadItem(.category)
    }
}

extension ExpenseViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryTextColor {
            textView.text = nil
            textView.textColor = .primaryTextColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "comment".localizeCapitalizingFirstLetter()
        }
        textView.textColor = .secondaryTextColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.comment = textView.text
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}
