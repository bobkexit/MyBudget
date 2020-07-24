//
//  TextFieldCell.swift
//  My budget
//
//  Created by Nikolay Matorin on 23.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate: AnyObject {
    func textFieldCell(_ cell: TextFieldCell, didEndEditingTextField textField: UITextField)
}

class TextFieldCell: UITableViewCell {
    
    weak var delegate: TextFieldCellDelegate?
        
    private(set) lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldEndEditing(_:)), for: [.editingDidEnd, .editingDidEndOnExit])
        return textField
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
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    @objc private func textFieldEndEditing(_ sender: UITextField) {
        delegate?.textFieldCell(self, didEndEditingTextField: sender)
    }
}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldCell(self, didEndEditingTextField: textField)
    }
}
