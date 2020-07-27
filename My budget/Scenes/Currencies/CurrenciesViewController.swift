//
//  CurrenciesViewController.swift
//  My budget
//
//  Created by Nikolay Matorin on 26.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

protocol CurrenciesViewControllerDelegate: AnyObject {
    func currenciesViewController(_ viewController: CurrenciesViewController, didSelectCurrnecyCode currencyCode: String?)
}

class CurrenciesViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    weak var delegate: CurrenciesViewControllerDelegate?
    
    private var selectedCurrencyCode: String?
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private let cellIdentifier = "CurrencyCode"
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, String> = makeDataSource()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width:  tableView.frame.size.width, height: 60.0)))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    } ()
    
    convenience init(selectedCurrencyCode: String?) {
        self.init()
        self.selectedCurrencyCode = selectedCurrencyCode
    }
    
    deinit {
        print(self, #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNavigationBar()
        configureSearchController()
        
        tableView.dataSource = dataSource
        tableView.delegate = self
    
        updateUI(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
        scrollToSelected()
    }
    
    private func configureViews() {
        view.backgroundColor = .richBlackForga30
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "currencies".localizeCapitalizingFirstLetter()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem?.tintColor = .babyPowder
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "search currency"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

private extension CurrenciesViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Section, String> {
        let reuseIdentifier = cellIdentifier
        return UITableViewDiffableDataSource<Section, String>(tableView: tableView) {
            [weak self] tableView, indexPath, currencyCode -> UITableViewCell? in
            
            guard let self = self else { return nil }
            
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
            cell.backgroundColor = .clear
            cell.tintColor = .orangePeel
            cell.textLabel?.text = Locale.current.localizedString(forCurrencyCode: currencyCode)
            cell.textLabel?.textColor = .babyPowder
            cell.selectionColor(.orangePeel)
            
            cell.detailTextLabel?.text = currencyCode
            cell.detailTextLabel?.textColor = .babyPowder60
            
            if currencyCode == self.selectedCurrencyCode {
                cell.accessoryType = .checkmark
            }
 
            return cell
        }
    }
    
    func updateUI(animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Locale.commonISOCurrencyCodes, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func performSearch(with searchText: String?, animated: Bool) {
        guard let searchText = searchText?.capitalized else {
            updateUI(animated: true)
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        let currencies = Locale.commonISOCurrencyCodes.filter {
            $0.capitalized.contains(searchText)
                || Locale.current.localizedString(forCurrencyCode: $0)?.capitalized.contains(searchText) == true
        }
        snapshot.appendItems(currencies, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func scrollToSelected() {
        guard let selectedCurrencyCode = selectedCurrencyCode,
            let indexPath = dataSource.indexPath(for: selectedCurrencyCode) else { return }
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}

extension CurrenciesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currencyCode = dataSource.itemIdentifier(for: indexPath) else { return }
        selectedCurrencyCode = currencyCode
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.currenciesViewController(self, didSelectCurrnecyCode: currencyCode)
        navigationController?.popViewController(animated: true)
    }
}

extension CurrenciesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        performSearch(with: searchController.searchBar.text, animated: true)
    }
}
