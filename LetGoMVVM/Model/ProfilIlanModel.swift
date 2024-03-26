//
//  ProfilIlanModel.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 7.01.2024.
//

// ProfilIlan.swift

import Foundation

struct ProfilIlan: Codable {
    let id: String
    let baslik: String
    let resim: String
    let icerik: String
    let fiyat: String
    let kullaniciid: String
}
