//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 24/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//
import UIKit
struct K {
    static let appName = ""
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandBlue"
        static let lightPurple = "White"
       // static let blue = "BrandBlue"
       // static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let signalName = "signal"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
        static let imgm = "image"
    }
    static func alert(title:String, message: String, vc:UIViewController){
        
        let al=UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        al.addAction(ok)
        
        vc.present(al, animated: true, completion: nil)
    }
}
