//
//  KayitOlVC.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 29.08.2023.
//

import UIKit

class KayitOlVC: UIViewController {
    
    //MARK: - GÖRSEL NESNELER
    
    @IBOutlet weak var adSoyadTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var parolaTF: UITextField!
    
    //MARK: - VIEW MODEL
    
    let kayitOlViewModel = KayitOlViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func kayitOlClicked(_ sender: Any) {
        
        guard let adSoyad = adSoyadTF.text, let email = emailTF.text, let parola = parolaTF.text else {
                    return
        }
        
        let yeniKullanici = User(name: adSoyad, email: email, password: parola)
        
        kayitOlViewModel.kayitOl(user: yeniKullanici) { success, message in
            
            DispatchQueue.main.async {
                
                if success
                {
                    self.showAlert(title: "BAŞARILI", message: message, ButtonTitle: "Tamam")
                    //self.performSegue(withIdentifier: "toAnasayfa", sender: nil)
                }
                else
                {
                    self.showAlert(title: "BAŞARISIZ", message: "Kayıt oluşturulurken bir hata oluştu!", ButtonTitle: "Tekrar Dene")
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func oturumAcClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toGiris", sender: nil)
    }
}
