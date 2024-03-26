//
//  ProfilViewModel.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 10.01.2024.
//

import Foundation

class userPref {
    func loginStatus() -> Int {
        if let status = UserDefaults.standard.object(forKey: Routes.loginstatus) as? Int {
            return status
        }
        return 0
    }
    func loginStatusSet(input: Int) {
        UserDefaults.standard.set(input, forKey: Routes.loginstatus)
    }
    func loginStatusLogOut() {
        UserDefaults.standard.removeObject(forKey: Routes.loginstatus)
    }
    func getUserId() -> String? {
        if let uid = UserDefaults.standard.object(forKey: "kullaniciid") as? String {
            return uid
        }
        return nil
    }
}
