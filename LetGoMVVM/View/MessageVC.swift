//
//  MessageVC.swift
//  LetGoMVVM
//
//  Created by Ümit Örs on 29.01.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MessageVC: UIViewController {
    private let auth : Auth = Auth.auth()
    @IBOutlet weak var backBtn: UIImageView!
    
    @IBOutlet weak var sendBtn: UIImageView!
    @IBOutlet weak var inputMessage: UITextField!
    @IBOutlet weak var tb: UITableView!
    
    var selectedData: AkisModel?
    
    private let ref : Firestore = Firestore.firestore()
    private let viewModelMessage = MessageViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backFunc)))
        
        sendBtn.isUserInteractionEnabled = true
        sendBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendFunction)))
        
        getData()
        
    }
    private var messageList = [MessageModel]()
    private func getData(){
        if let selectedData = selectedData {
            
            viewModelMessage.firebase(aliciuid: selectedData.kullaniciid, gondericiuid: auth.currentUser?.uid ?? "") { model in
                self.messageList = model
                self.tb.reloadData()
            }
        }
        
    }
    @objc func backFunc() {
        
        self.dismiss(animated: true)
    }
    @objc func sendFunction(_ sender: UITapGestureRecognizer){
        let message = inputMessage.text!
        
        if  !message.isEmpty {
            if let selectedData = selectedData {
                //12
                let alici = selectedData.kullaniciid
                //23
                let gonderici = auth.currentUser?.uid ?? ""
                let mesajArray = ["message":message,"kullaniciuid":gonderici,"timestamp":FieldValue.serverTimestamp()] as [String : Any]
                ref.collection("message").document(alici + gonderici).collection("text").document().setData(mesajArray, merge: true) { error in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.inputMessage.text = nil
                        }
                        self.ref.collection("message").document(gonderici + alici).collection("text").document().setData(mesajArray,merge: true) { error in
                            if error == nil {
                                self.ref.collection("story").document(gonderici).collection("list").document(alici).setData(mesajArray, merge: true) { error in
                                    if error == nil {
                                        self.ref.collection("story").document(alici).collection("list").document(gonderici).setData(mesajArray, merge: true) { error in
                                            if error == nil {
                                                
                                            }
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                    }
                }
            }
        }else {
            print("mesaj yazınız boş olamaz")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MessageVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MessageCell
        let item = messageList[indexPath.row]
        if item.kullaniciuid == auth.currentUser?.uid ?? "" {
            cell = tb.dequeueReusableCell(withIdentifier: "cellSeconday", for: indexPath) as! MessageCell
        }else {
            cell = tb.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCell
        }
        cell.lbl.text = item.message
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
}
