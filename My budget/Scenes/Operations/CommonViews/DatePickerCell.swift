//
//  DatePickerCell.swift
//  My budget
//
//  Created by Nikolay Matorin on 28.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

protocol DatePickerCellDelegate: AnyObject {
    func datePickerCell(_ cell: DatePickerCell, didChangeDate date: Date)
}

class DatePickerCell: UITableViewCell {
    weak var delegate: DatePickerCellDelegate?
    
    private(set) lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        if #available(iOS 14.0, *) {
            // TODO: - Uncoment
            //datePicker.preferredDatePickerStyle = .inline
        } 
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
        return datePicker
    } ()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    private func configureViews() {
        contentView.addSubview(datePicker)
       
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: contentView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            //datePicker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    @objc private  func dateDidChange(_ sender: UIDatePicker) {
         delegate?.datePickerCell(self, didChangeDate: sender.date)
    }
}
