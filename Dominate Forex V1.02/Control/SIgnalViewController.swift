//
//  SIgnalViewController.swift
//  Dominate Forex V1.01
//
//  Created by mac on 11/28/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class SIgnalViewController: UIViewController {

    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var txtF: UITextField!
    @IBOutlet weak var sendB: UIButton!
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if "autoswingexpert@gmail.com" != Auth.auth().currentUser?.email {
            txtF.isHidden = true
            sendB.isHidden = true
        }
        tableV.dataSource = self
        tableV.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.signalName)
            .order(by: K.FStore.dateField, descending: true)
            .addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String , let tim = data[K.FStore.dateField] as? Double{

                            let date = Date(timeIntervalSince1970: tim)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                            dateFormatter.timeZone = .current
                            let localDate = dateFormatter.string(from: date)
                            
                            let newMessage = Message(sender: messageSender, body: messageBody, time: String(localDate))
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                   self.tableV.reloadData()
//                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
//                                self.tableV.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    

    @IBAction func sendPr(_ sender: UIButton) {
        if txtF.text != "" {
        if let messageBody = txtF.text, let messageSender = Auth.auth().currentUser?.email {
                   db.collection(K.FStore.signalName).addDocument(data: [
                       K.FStore.senderField: messageSender,
                       K.FStore.bodyField: messageBody,
                       K.FStore.dateField: Date().timeIntervalSince1970
                   ]) { (error) in
                       if let e = error {
                           print("ss There was an issue saving data to firestore, \(e)")
                       } else {
                           print("ss Successfully saved data.")
                           
                           DispatchQueue.main.async {
                                self.txtF.text = ""
                            self.view.endEditing(true)
                           }
                       }
                   }
               }
        }
    }
    
}

extension SIgnalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        cell.timeLab.text = message.time
        
        //This is a message from the current user.
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            cell.label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      
        return cell
    }
}


 
