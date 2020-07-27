//
//  AccountTypeCell.swift
//  My budget
//
//  Created by Nikolay Matorin on 26.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class AccountTypeCell: UICollectionViewCell {
    
    private(set) lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .babyPowder
        label.textAlignment = .center
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    private func configureViews() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = contentView.bounds.height / 2
        contentView.layer.masksToBounds = true
    }
}
