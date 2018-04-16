//
//  GeneralSettings.swift
//  My budget
//
//  Created by Николай Маторин on 16.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

final class UserSettings {
    public static let shared = UserSettings()

    private var defaults = UserDefaults.standard
    
    var defaultCurrencyCode: String?
    var defaultAccount: String?
    var defaultCategory: String?
    
    private init() {
        
    }
}
