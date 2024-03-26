//
//  WebServices.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 1.09.2023.
//
import Foundation

class WebServices {
    static let shared = WebServices()

    // Genel veri çekme işlemi için metod
    func verileriGetir(aramaMetni: String, completion: @escaping ([AkisModel]?) -> Void) {
        let url = URL(string: "https://gulsumaydemir.com/liste.php")

        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("Hata: \(error)")
                completion(nil)
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionary = json as? [String: Any],
                       let liste = dictionary["liste"] as? [[String: Any]] {
                        var akisModeller: [AkisModel] = []
                        for item in liste {
                            if let id = item["id"] as? String,
                               let baslik = item["baslik"] as? String,
                               let fiyat = item["fiyat"] as? String,
                               let resim = item["resim"] as? String,
                               let icerik = item["icerik"] as? String,
                               let kullaniciid = item["kullaniciid"] as? String {
                               let akisModel = AkisModel(id: id, baslik: baslik, resim:resim, icerik: icerik, fiyat: fiyat, kullaniciid: kullaniciid)
                                akisModeller.append(akisModel)
                            }
                        }
                        
                        if !aramaMetni.isEmpty {
                            akisModeller = akisModeller.filter { $0.baslik.lowercased().contains(aramaMetni.lowercased()) }
                        }

                        completion(akisModeller)
                    } else {
                        print("JSON veri yapısı beklenenden farklı.")
                        completion(nil)
                    }
                } catch {
                    print("Veri çözümleme hatası: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    
    func getProfileList(completion: @escaping (ProfileRSSModel) -> Void)
    {
        TempWebService().web(endpoint: Routes.listeendpoint, HttpMethod: .get) { data in
            
            if let json = try? JSONDecoder().decode(ProfileRSSModel.self, from: data) {
                
                print("data decoder")
                if let uid = userPref().getUserId() {
                    print("uid success")
                    let filteredData = json.liste.filter{$0.kullaniciid == uid}
                    let updateModel = ProfileRSSModel(liste: filteredData)
                    completion(updateModel)
                }
                
            }
            
            
        }
    }
    
}
