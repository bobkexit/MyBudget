//
//  DictionaryVC.swift
//  My budget
//
//  Created by Николай Маторин on 19.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class AccountsVC: BaseTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addButtomPressed(_ sender: Any) {
        let addAccountVC = AddAccountVC()
        addAccountVC.modalPresentationStyle = .custom
        present(addAccountVC, animated: true, completion: nil)
        
    }
    

}
