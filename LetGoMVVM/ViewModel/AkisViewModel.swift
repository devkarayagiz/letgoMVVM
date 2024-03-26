//
//  AkisViewModel.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 31.08.2023.
//

import Foundation

class AkisViewModel {
    
    var akisModeller: [AkisModel] = []
    
    
    func verileriCek(aramaMetni: String, completion: @escaping () -> Void) {
        WebServices.shared.verileriGetir(aramaMetni: aramaMetni) { [weak self] (akisModeller) in
            if let akisModeller = akisModeller {
                self?.akisModeller = akisModeller
                completion()
            }
        }
    }
    
    func veriSayisi() -> Int {
        return akisModeller.count
    }
    
    func veri(index: Int) -> AkisModel {
        return akisModeller[index]
    }
    
    
}
