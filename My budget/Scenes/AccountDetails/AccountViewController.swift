//
//  AccountViewController.swift
//  My budget
//
//  Created by Nikolay Matorin on 26.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

protocol AccountViewControllerDelegate: AnyObject {
    func accountViewController(_ viewController: AccountViewController, didSelectCurrencyCode currencyCode: String?)
    func accountViewControllerDidSaveAccount(_ viewController: AccountViewController)
}

class AccountViewController: UIViewController {
    
    weak var delegate: AccountViewControllerDelegate?
    
    enum Section: Int, CaseIterable {
        case name
        case currency
        case type
        
        var cellIdentifier: String {
            switch self {
            case .name:
                return "AccountNameCell"
            case .currency:
                return "AccountCurrencyCell"
            case .type:
                return "AccountTypesCell"
            }
        }
    }
    
    private var accountContoller: AccountContollerProtocol?
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Section> = makeAccountDataSource()
    
    private lazy var accountTypesDataSource: UICollectionViewDiffableDataSource<Section, AccountKind> = makeAccountTypeDataSource()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width:  tableView.frame.size.width, height: 60.0)))
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: Section.name.cellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Section.currency.cellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Section.type.cellIdentifier)
        return tableView
    } ()
    
    private let accountTypeCellIdentifier = "AccountTypeCell"
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(AccountTypeCell.self, forCellWithReuseIdentifier: accountTypeCellIdentifier)
        return collectionView
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

    convenience init(accountContoller: AccountContollerProtocol) {
        self.init()
        self.accountContoller = accountContoller
    }
    
    deinit {
        print(self, #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNavigationBar()
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        collectionView.dataSource = accountTypesDataSource
        collectionView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        updateUI(animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.layer.cornerRadius = saveButton.bounds.height / 2
        
        if let accountType = accountContoller?.accountType,
            let indexPath = accountTypesDataSource.indexPath(for: accountType) {
            collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem?.tintColor = .primaryTextColor
    }
    
    private func configureViews() {
        view.backgroundColor = .primaryBackgroundColor
        view.addSubview(tableView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            saveButton.heightAnchor.constraint(equalToConstant: 48.0),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func saveButtonTapped(_ sender: UIButton) {
        let accountName = accountContoller?.accountName
        if accountName == nil || accountName?.isEmpty == true   {
            accountContoller?.updateAccount(name: "new account".localizeCapitalizingFirstLetter())
        }
        
        accountContoller?.saveAccount()
        delegate?.accountViewControllerDidSaveAccount(self)
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func reloadSection(_ section: Section, animated: Bool = false) {
        if section == .type {
            var snapshot = accountTypesDataSource.snapshot()
            snapshot.reloadSections([section])
            accountTypesDataSource.apply(snapshot, animatingDifferences: animated)
        } else {
            var snapshot = dataSource.snapshot()
            snapshot.reloadSections([section])
            dataSource.apply(snapshot, animatingDifferences: animated)
        }
    }
}

private extension AccountViewController {
    func makeAccountDataSource() -> UITableViewDiffableDataSource<Section, Section>  {
        let dataSource = UITableViewDiffableDataSource<Section, Section>(tableView: tableView) {
            [weak self] tableView, indexPath, item -> UITableViewCell? in
            guard let self = self, let section = Section(rawValue: indexPath.section) else { return nil }
            return self.makeCell(for: section, at: indexPath, in: tableView)
        }
        return dataSource
    }
    
    func makeAccountTypeDataSource() -> UICollectionViewDiffableDataSource<Section, AccountKind> {
        let reuseIdentifier = accountTypeCellIdentifier
        let dataSource = UICollectionViewDiffableDataSource<Section, AccountKind>(collectionView: collectionView) {
            [weak accountContoller] collectionView, indexPath, accountType -> UICollectionViewCell? in

            guard let accountContoller = accountContoller, let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier, for: indexPath) as? AccountTypeCell else { return nil }

            cell.titleLabel.text = accountType.description()
            cell.isSelected = accountContoller.accountType == accountType

            if cell.isSelected {
                cell.contentView.backgroundColor = .actionColor
            } else {
                cell.contentView.backgroundColor = .secondaryTextColor
            }

            return cell
        }
        return dataSource
    }
    
    func updateUI(animated: Bool = false) {
        guard let controller = accountContoller else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Section>()
        
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems([$0], toSection: $0) }
        
        dataSource.apply(snapshot, animatingDifferences: animated)
        
        var accountTypesSnapshot = NSDiffableDataSourceSnapshot<Section, AccountKind>()
        accountTypesSnapshot.appendSections([.type])
        accountTypesSnapshot.appendItems(controller.accountTypes, toSection: .type)
        
        accountTypesDataSource.apply(accountTypesSnapshot, animatingDifferences: animated)
    }

    private func makeCell(for section: Section, at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell? {
        switch section {
        case .name:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: section.cellIdentifier, for: indexPath) as? TextFieldCell else { return nil }
            cell.backgroundColor = .secondaryBackgroundColor
            cell.textField.backgroundColor = .secondaryBackgroundColor
            cell.textField.textColor = .primaryTextColor
            cell.textField.tintColor = .actionColor
            cell.textField.clearButtonMode = .whileEditing
            cell.textField.placeholder = "new account".localizeCapitalizingFirstLetter()
            cell.textField.text = accountContoller?.accountName
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .currency:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: section.cellIdentifier)
            cell.backgroundColor = .secondaryBackgroundColor
            cell.textLabel?.textColor = .primaryTextColor
            cell.detailTextLabel?.textColor = .secondaryTextColor
            cell.textLabel?.text = "currency".localizeCapitalizingFirstLetter()
            cell.detailTextLabel?.text = accountContoller?.currencyCode
            cell.accessoryType = .disclosureIndicator
            cell.selectionColor(.actionColor)
            
            return cell
        case .type:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            collectionView.removeFromSuperview()
            cell.contentView.addSubview(collectionView)
            NSLayoutConstraint.activate([
                collectionView.heightAnchor.constraint(equalToConstant: 24),
                collectionView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                collectionView.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor)
            ])
            return cell
        }
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let section = Section(rawValue: indexPath.section), section == .currency {
            tableView.deselectRow(at: indexPath, animated: true)
            let currencyCode = accountContoller?.currencyCode
            delegate?.accountViewController(self, didSelectCurrencyCode: currencyCode)
        }
    }
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let accountType = accountTypesDataSource.itemIdentifier(for: indexPath) else { return }
        accountContoller?.updateAccount(type: accountType)
        reloadSection(.type)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let accountType = accountTypesDataSource.itemIdentifier(for: indexPath)
        let estimatedFrame = estimatedFrameFor(accountType?.description() ?? "")
        
        let paddig: CGFloat = 30
        return CGSize(width: estimatedFrame.width + paddig, height: collectionView.bounds.height)
    }
    
    private func estimatedFrameFor(_ text: String, font: UIFont = .systemFont(ofSize: 13)) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
}

extension AccountViewController: TextFieldCellDelegate {
    func textFieldCell(_ cell: TextFieldCell, didEndEditingTextField textField: UITextField) {
        guard let name = textField.text else { return }
        accountContoller?.updateAccount(name: name)
        reloadSection(.name)
    }
}

extension AccountViewController: CurrenciesViewControllerDelegate {
    func currenciesViewController(_ viewController: CurrenciesViewController, didSelectCurrnecyCode currencyCode: String?) {
        accountContoller?.updateAccount(currencyCode: currencyCode)
        reloadSection(.currency)
    }
}
