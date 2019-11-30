//
//  MainViewController.swift
//  Dominate Forex V1.01
//
//  Created by mac on 11/28/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
               navigationItem.backBarButtonItem = backButton
    }
    

    func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
           // performSegue(withIdentifier: "toLog", sender: nil)
        }
        catch {
            print("signout error")
        }
    }
    
}
