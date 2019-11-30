//
//  SignViewController.swift
//  Dominate Forex V1.01
//
//  Created by mac on 11/28/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class SignViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func signBtn(_ sender: UIButton) {
        if let uName = userName.text, let uPass = userPassword.text, let uEmail = userEmail.text {
            Auth.auth().createUser(withEmail: uEmail, password: uPass) { (Auth, Err) in
                if Err != nil {
                    K.alert(title: "Error", message: Err!.localizedDescription,vc: self)
                }
                else {
                    
                let ins = ["user name":uName,"user email":uEmail,"user password":uPass] as [String:Any]
                let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ins)
                    
                    self.performSegue(withIdentifier: "toNa", sender: nil)
                    
                }
            }
        }
        else {
            K.alert(title: "Error", message: "Please fil all the data",vc: self)
        }
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
