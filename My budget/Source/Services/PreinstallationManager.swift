//
//  DataService.swift
//  My budget
//
//  Created by Николай Маторин on 22.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class PreinstallationManager {
    public static let shared = PreinstallationManager()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        
    }
    
    func installData()  {
        //loadCurrencies()
        userDefaults.set(true, forKey: Constants.UserDefaults.firstLaunch)
    }
    
    
}
