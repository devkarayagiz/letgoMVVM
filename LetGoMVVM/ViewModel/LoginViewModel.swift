//
//  LoginViewModel.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 31.08.2023.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    private let auth : Auth = Auth.auth()
    func loginUser(email: String, password: String, completion: @escaping (UserResponse?) -> Void) {
        let urlString = "https://gulsumaydemir.com/uyegiris.php"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "email=\(email)&sifre=\(password)"
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let userResponse = try decoder.decode(UserResponse.self, from: data)
                    self.auth.signIn(withEmail: email, password: password) { Result, error in
                        if error == nil {
                            completion(userResponse)
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
        }.resume()
    }
}
