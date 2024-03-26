//
//  ProfilViewModel.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 10.01.2024.
//

import Foundation
import FirebaseFirestore


class MessageViewModel {
    private let ref : Firestore = Firestore.firestore()
    func firebase(aliciuid:String,gondericiuid:String,completion: @escaping([MessageModel]) -> Void){
        ref.collection("message").document(gondericiuid + aliciuid).collection("text").order(by: "timestamp", descending: false).addSnapshotListener { snap, error in
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
}
