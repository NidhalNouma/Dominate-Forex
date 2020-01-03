//
//  SIgnalViewController.swift
//  Dominate Forex V1.01
//
//  Created by mac on 11/28/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class SIgnalViewController: UIViewController {

    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var txtF: UITextField!
    @IBOutlet weak var sendB: UIButton!
    @IBOutlet weak var imgP: UIButton!
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var messages: [Message] = []
    var imgC = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         if "autoswingexpert@gmail.com" != Auth.auth().currentUser?.email &&  "nidhal@gmail.com" != Auth.auth().currentUser?.email{
            txtF.isHidden = true
            sendB.isHidden = true
            imgP.isHidden = true
        }
        tableV.dataSource = self
        tableV.delegate = self
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
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String , let tim = data[K.FStore.dateField] as? Double , let imgDo = data[K.FStore.imgm] as? String{

                            let date = Date(timeIntervalSince1970: tim)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                            dateFormatter.timeZone = .current
                            
                            let localDate = dateFormatter.string(from: date)
                            
//                            var dataSe:Data?
//
//                            let islandRef = self.storage.child("signalimgs/\(String(describing: imgDo))")
//
//                            islandRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
//                              if let error = error {
//                                print("no image \(error)")
//                                dataSe=nil
//                              } else {
//                                    print("data \(String(describing: imgDo))")
//                                dataSe = data!
//                              }
//                            }
                            
                            
                            let newMessage = Message(sender: messageSender, body: messageBody, time: String(localDate), img: imgDo)
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
    
    @IBAction func imgChoose(_ sender: UIButton) {
        let pick =  UIImagePickerController()
        pick.delegate = self
        pick.sourceType = .photoLibrary
        present(pick, animated: true, completion: nil)
    }
    
    @IBAction func sendPr(_ sender: UIButton) {
        let ti = Date().timeIntervalSince1970
        var turls:String = ""
        let storR = self.storage.child("Object signalimgs")
        if let data = self.imgC.jpegData(compressionQuality: 0.5) {
            let mountainImagesRef = storR.child("\(ti).jpg")
            mountainImagesRef.putData(data, metadata: nil) { (metaData, err) in
                if err == nil {
                    mountainImagesRef.downloadURL { (url, er) in
                        if er == nil {
                            turls = url!.absoluteString
                            if self.txtF.text != "" {
                                if let messageBody = self.txtF.text, let messageSender = Auth.auth().currentUser?.email {
                                    self.db.collection(K.FStore.signalName).addDocument(data: [
                                           K.FStore.senderField: messageSender,
                                           K.FStore.bodyField: messageBody,
                                           K.FStore.dateField: ti,
                                           K.FStore.imgm: turls
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
                }
            }
            imgP.setTitle("", for: UIControl.State.normal)
            print("data is \(data)")
        }else{
            if txtF.text != "" {
            if let messageBody = txtF.text, let messageSender = Auth.auth().currentUser?.email {
                       db.collection(K.FStore.signalName).addDocument(data: [
                           K.FStore.senderField: messageSender,
                           K.FStore.bodyField: messageBody,
                           K.FStore.dateField: ti,
                           K.FStore.imgm: turls
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
    
}

extension SIgnalViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell

        if  message.img == "" {
            cell.hightImg.constant = 0
            //cell.imgNew.image = UIImage(named: "Background")
          } else {
            cell.hightImg.constant = 170
            cell.imgNew?.sd_setImage(with: URL(string: message.img), completed: nil)
          }
        
        
        cell.label.text = message.body
        cell.timeLab.text = message.time
               
        cell.leftImageView.isHidden = true
        cell.rightImageView.isHidden = true
        cell.messageBubble.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        cell.label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        if(message.img != ""){
            
            performSegue(withIdentifier: "toImg", sender: message.img)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImg"{
            if let viw = segue.destination as? ImgViewController, let na = sender as? String {
                
                viw.imgT = na
            }
        }
    }
    
}

extension SIgnalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imgC = info[.originalImage] as! UIImage
        
        self.dismiss(animated: true, completion: nil)
        imgP.setTitle("1", for: UIControl.State.normal)
}
}
