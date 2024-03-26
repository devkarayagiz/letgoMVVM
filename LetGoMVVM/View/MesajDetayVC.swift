//
//  MesajDetayVC.swift
//  LetGoMVVM
//
//  Created by Ümit Örs on 29.01.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MesajDetayVC: UIViewController {
    var aliciid = ""
    private let auth : Auth = Auth.auth()
    @IBOutlet weak var backBtn: UIImageView!
    
    @IBOutlet weak var sendBtn: UIImageView!
    @IBOutlet weak var inputMessage: UITextField!
    @IBOutlet weak var tb: UITableView!
    private let ref : Firestore = Firestore.firestore()
    private let viewModelMessage = MessageViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backFunc)))
        
        sendBtn.isUserInteractionEnabled = true
        sendBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendFunction)))
        
        getData()
        // Do any additional setup after loading the view.
    }
    
    private var messageList = [MessageModel]()
    private func getData(){
        viewModelMessage.firebase(aliciuid: aliciid, gondericiuid: auth.currentUser?.uid ?? "") { model in
            self.messageList = model
            self.tb.reloadData()
        }
        
    }
    @objc func backFunc() {
        
        self.dismiss(animated: true)
    }
    @objc func sendFunction(_ sender: UITapGestureRecognizer){
        let message = inputMessage.text!
        
        if  !message.isEmpty {
            //12
            let alici = aliciid
            //23
            let gonderici = auth.currentUser?.uid ?? ""
            let mesajArray = ["message":message,"kullaniciuid":gonderici,"timestamp": FieldValue.serverTimestamp()] as [String : Any]
            ref.collection("message").document(alici + gonderici).collection("text").document().setData(mesajArray, merge: true) { error in
                if error == nil {
                    self.ref.collection("message").document(gonderici + alici).collection("text").document().setData(mesajArray,merge: true) { error in
                        if error == nil {
                            DispatchQueue.main.async {
                                self.inputMessage.text = nil
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
extension MesajDetayVC : UITableViewDelegate, UITableViewDataSource {
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
