//
//  SettingsCell.swift
//  My budget
//
//  Created by Николай Маторин on 19.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class SettingsCell: BaseCell {
    
    func configure(_ text: String) {
       self.textLabel?.text = text.capitalized
    }
    
}
