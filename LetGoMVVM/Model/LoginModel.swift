//
//  LoginModel.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 11.01.2024.
//

import Foundation

struct UserResponse: Codable {
    let message: String
    let liste: [UserLogin]
}

struct UserLogin: Codable {
    let adsoyad: String
    let id: String
}
