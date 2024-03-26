//
//  ProfilViewModel.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 10.01.2024.
//

import Foundation

struct ProfileRSSModel : Decodable {
    var liste : [ProfileRSSArrayModel]
}
struct ProfileRSSArrayModel : Decodable {
    var id : String
    var baslik : String
    var resim : String
    var icerik : String
    var fiyat : String
    var kullaniciid : String
}
