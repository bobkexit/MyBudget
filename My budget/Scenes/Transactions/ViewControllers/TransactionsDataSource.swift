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
