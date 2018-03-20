//
//  IncomingAndExpensesVC.swift
//  My budget
//
//  Created by Николай Маторин on 20.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class CategoriesVC: BaseTableVC {
    
    var categoryType: Category.TypeCategory!
    var repository = RealmRepository<RealmCategory>()
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        print(categoryType)
        categories = repository.get(filteredBy: "typeId = \(categoryType.rawValue)")
        print(categories)
    }
    
    override func setup() {
        super.setup()
        setViewTitle()
    }
    
    func setViewTitle() {
        switch categoryType {
        case .expense:
            title = AppDictionary.expenses.rawValue.capitalized
        case .income:
             title = AppDictionary.incomings.rawValue.capitalized
        default:
            return
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
