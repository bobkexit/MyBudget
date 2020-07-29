//
//  TransactionsDataSource.swift
//  My budget
//
//  Created by Николай Маторин on 18.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit


class TransactionsDataSource: UITableViewDiffableDataSource<Date, TransactionDTO> {
    
    struct Actions {
        var deleteTransaction: ((_ transaction: TransactionDTO) -> Void)?
    }
    
    var actions: Actions = Actions()
    
    var transactionsController: TransactionsControllerProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter
    } ()
    
    convenience init(tableView: UITableView, transactionsController: TransactionsControllerProtocol?) {
        let reuseIdentifier = TransactionCell.reuseIdentifier
        self.init(tableView: tableView) { tableView, indexPath, transaction in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: reuseIdentifier,
                for: indexPath) as? TransactionCell else { return nil }
            
            TransactionCellConfigurator(cell: cell, transaction: transaction).configureCell()
            
            return cell }
        self.transactionsController = transactionsController
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let item = itemIdentifier(for: indexPath) {
            defaultRowAnimation = .fade
            actions.deleteTransaction?(item)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension TransactionsDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let controller = transactionsController else { return nil }
        let label = makeSectionLabel()
        let dates = controller.getDates()
        let date = dates[section]
        label.text = dateFormatter.string(from: date)
        return label
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    private func makeSectionLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.primaryTextColor.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        return label
    }
}
