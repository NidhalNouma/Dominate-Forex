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
    

    func logout() {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toLog", sender: nil)
            print("Try to signout")
            //self.dismiss(animated: true, completion: nil)
        }
        catch {
            print("signout error")
        }
    }
    
    
    @IBAction func logOutt(_ sender: Any) {
        logout()
    }
}
