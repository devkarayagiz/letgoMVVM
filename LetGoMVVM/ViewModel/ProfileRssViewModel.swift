//
//  ProfilViewModel.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 10.01.2024.
//

import Foundation


class ProfileRssViewModel {
    let connect = WebServices.shared
    
    func getData(completion: @escaping(ProfileRSSModel) -> Void) {
        connect.getProfileList { ProfileRSSModel in
            completion(ProfileRSSModel)
        }
    }
}
