//
//  TransactionCell.swift
//  My budget
//
//  Created by Николай Маторин on 17.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    public static let reuseIdentifier = String(describing: TransactionCell.self)
    
    private lazy var primaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        label.textColor = .babyPowder
        return label
    } ()
    
    private lazy var secondaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.babyPowder.withAlphaComponent(0.6)
        return label
    } ()
    
    private lazy var tertiaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .imperialRed
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    } ()
    
    private lazy var secondaryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [primaryLabel, secondaryLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    } ()
    
    private lazy var primaryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [secondaryStackView, tertiaryLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    private func configureViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(primaryStackView)
        NSLayoutConstraint.activate([
            primaryStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            primaryStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            primaryStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            primaryStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
}

extension TransactionCell {
    func mockup() {
        primaryLabel.text = "Long lnong long category "
        secondaryLabel.text = "11:20 - Credit card blah blah blah"
        tertiaryLabel.text = "-15 500.30 ₽"
    }
}
