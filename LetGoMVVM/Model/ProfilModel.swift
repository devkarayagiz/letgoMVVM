//
//  ProfilModel.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 7.01.2024.
//

import Foundation

struct Profil: Codable {
    var adsoyad: String
    var resim: String
}

struct ProfilResponse: Codable {
    var liste: [Profil]
    var success: Int
    var message: String
}
