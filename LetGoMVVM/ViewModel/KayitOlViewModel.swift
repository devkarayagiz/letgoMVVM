//
//  KayitOlViewModel.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 29.08.2023.
//

import Foundation
import FirebaseAuth

class KayitOlViewModel
{
    private let auth : Auth = Auth.auth()
    
    func kayitOl(user : User, completion : @escaping(Bool, String) -> Void)
    {
        let urlString = URL(string: "https://gulsumaydemir.com/uyeol.php")
        var request = URLRequest(url: urlString!)
        request.httpMethod = "POST"
        let postData = "adsoyad=\(user.name)&email=\(user.email)&sifre=\(user.password)"
        request.httpBody = postData.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil || data == nil
            {
                print(error?.localizedDescription)
            }
            else
            {
                do
                {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        let success = json["success"] as? Int ?? 0
                        let message = json["message"] as? String ?? "Bilinmeyen hata."
                        self.auth.createUser(withEmail: user.email, password: user.password) {result, error  in
                            completion(success == 1, message)
                        }
                       
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                }
            }
            
        }.resume()
    }
}
