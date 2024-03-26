//
//  MesajStory.swift
//  LetGoMVVM
//
//  Created by Ümit Örs on 29.01.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MesajStory: UIViewController {
    @IBOutlet weak var tb: UITableView!
    private let auth : Auth = Auth.auth()
    private let ref : Firestore = Firestore.firestore()
    
    private var list = [MessageModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tb.delegate = self
        tb.dataSource = self
        // Do any additional setup after loading the view.
        firebase { model in
            self.list = model
            self.tb.reloadData()
        }
    }
    
    func firebase(completion: @escaping([MessageModel]) -> Void){
        ref.collection("story").document(auth.currentUser?.uid ?? "").collection("list").order(by: "timestamp", descending: false).addSnapshotListener { snap, error in
            if error != nil {
                return
            }
            guard let snapshot = snap else {return}
            var modelArray = [MessageModel]()
            for i in snapshot.documents {
                do {
                    let message = try i.data(as: MessageModel.self)
                    modelArray.append(message)
                }catch {
                    print(error.localizedDescription)
                }
            }
            completion(modelArray)
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
extension MesajStory : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = list[indexPath.row]
        cell.textLabel?.text = item.message
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = list[indexPath.row]
        if let dc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MesajDetayVC") as? MesajDetayVC {
            dc.modalPresentationStyle = .fullScreen
            dc.aliciid = item.kullaniciuid
            self.present(dc, animated: true)
        }
    }
}
