//
//  GirisYapVC.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 29.08.2023.
//

import UIKit

class GirisYapVC: UIViewController {
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var parolaTF: UITextField!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func girisYapClicked(_ sender: Any) {
        
        guard let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      let password = parolaTF.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      !email.isEmpty, !password.isEmpty else {
                    print("Boş alan var")
                    return
                }
        
        viewModel.loginUser(email: email, password: password) { userResponse in
            if let userResponse = userResponse {
                if userResponse.message == "basarili" {
                    userPref().loginStatusSet(input: 1)
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(userResponse.liste[0].adsoyad, forKey: "adsoyad")
                        UserDefaults.standard.set(userResponse.liste[0].id, forKey: "kullaniciid")
                        UserDefaults.standard.set("Email", forKey: "email")
                        self.performSegue(withIdentifier: "toAkis", sender: nil)
                    }
                } else if userResponse.message == "basarisiz" {
                    print("basarisiz")
                }
            }
        }
        
    }
    
    
    @IBAction func kayitOlClicked(_ sender: Any) {
        performSegue(withIdentifier: "toKayit", sender: nil)
    }
    
}
