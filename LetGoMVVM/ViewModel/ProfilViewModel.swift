//
//  ProfilViewModel.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 7.01.2024.
//

import Foundation

class ProfilViewModel {
    var profil: [Profil]? {
        didSet {
            self.updateUI?()
        }
    }

    var updateUI: (() -> Void)?

    func fetchProfilData(forUserID userID: String) {
        guard let url = URL(string: "https://www.gulsumaydemir.com/getprofil.php") else {
            print("Geçersiz URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let postString = "id=\(userID)"
        request.httpBody = postString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Bilinmeyen Hata")
                return
            }

            // API'dan gelen yanıtı yazdır
            let responseString = String(data: data, encoding: .utf8)
            print("Yanıt: \(responseString ?? "Boş yanıt")")

            do {
                let profilResponse = try JSONDecoder().decode(ProfilResponse.self, from: data)
                if profilResponse.success == 1 {
                    self.profil = profilResponse.liste
                } else {
                    print("Profil verisi çekilemedi: \(profilResponse.message)")
                }
            } catch {
                print("JSON çözümleme hatası: \(error.localizedDescription)")
            }
        }.resume()
    }

}
