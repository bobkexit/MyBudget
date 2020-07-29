//
//  TransactionCellConfigurator.swift
//  My budget
//
//  Created by Николай Маторин on 17.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

protocol CellConfigurable {
    func configureCell()
}

class TransactionCellConfigurator: CellConfigurable {
    private let cell: TransactionCell
    
    private let transaction: TransactionDTO
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter
    } ()
    
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencyCode = transaction.account?.currencyCode
        formatter.numberStyle = .currencyAccounting
        return formatter
    } ()
    
    init(cell: TransactionCell, transaction: TransactionDTO) {
        self.cell = cell
        self.transaction = transaction
    }
    
    func configureCell() {
        cell.selectionStyle = .none
        updatePrimaryLabel()
        updateSecondaryLabel()
        updateTertiaryLabel()
    }
    
    private func updatePrimaryLabel() {
        cell.primaryLabel.text = transaction.category?.name
    }
    
    private func updateSecondaryLabel() {
        var time = dateFormatter.string(from: transaction.date)
        if let account = transaction.account?.name {
            time += " - \(account)"
        }
        cell.secondaryLabel.text = time
    }
    
    private func updateTertiaryLabel() {
        let ammount = numberFormatter.string(from: NSNumber(value: transaction.ammount)) ?? ""
        
        var sign: String? = nil
        
        if let transactionType = transaction.category?.kind {
            sign = transactionType == .expense ? "-" : "+"
            cell.tertiaryLabel.textColor = sign == "-" ? .negativeAccentColor : .positiveAccentColor 
        }
        
        if !ammount.isEmpty, let sign = sign {
            cell.tertiaryLabel.text = sign + ammount
        }
    }
}
