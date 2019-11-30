//
//  ViewController.swift
//  Dominate Forex V1.01
//
//  Created by mac on 11/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func logInBtn(_ sender: UIButton) {
        
        if let passw=pass.text , let em=email.text {
        Auth.auth().signIn(withEmail: em, password: passw) { authResult, error in
            if error != nil {
                K.alert(title: "error", message: error!.localizedDescription, vc: self)
                            }
            else {
                self.performSegue(withIdentifier: "toNa", sender: nil)
            }
        }
        }
        else {
            K.alert(title: "error", message: "fill all the data", vc: self)
        }
        
    }
}

