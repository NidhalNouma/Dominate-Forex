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
                    self.alert(title: "Error", message: Err!.localizedDescription)
                }
                else {
                let ins = ["user name":uName,"user email":uEmail,"user password":uPass] as [String:Any]

                print(ins)
                    self.performSegue(withIdentifier: "toNa", sender: nil)
                }
            }
        }
        else {
           alert(title: "Error", message: "Please fil all the data")
        }
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func alert(title:String, message: String){
        
        let al=UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        al.addAction(ok)
        
        self.present(al, animated: true, completion: nil)
    }
}
