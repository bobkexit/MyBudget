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
        loadCurrencies()
        userDefaults.set(true, forKey: Constants.UserDefaults.firstLaunch)
    }
    
    private func loadCurrencies() {
        guard let url = Bundle.main.url(forResource: "currencies", withExtension: "json") else {
            fatalError("Can't find currencies.json")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSON(data: data)
            
            let parsedData = parseCurrenciesJson(json: json)
            DataManager.shared.createOrUpdate(data: parsedData)
        } catch  {
            print(error as Any)
        }
    }
    
    private func parseCurrenciesJson(json: JSON) -> [RealmCurrency] {
        var currencies = [RealmCurrency]()
        
        for (key,subJson):(String, JSON) in json {
            currencies.append(RealmCurrency(code: key, symbol: subJson.stringValue))
        }
        
        return currencies
    }
}