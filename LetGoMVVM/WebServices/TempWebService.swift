//
//  TempWebService.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 10.01.2024.
//

import Foundation

enum HttpMethod : String {
    case get = "GET"
    case post = "POST"
}

class TempWebService {
    func web(endpoint: String, HttpMethod: HttpMethod, completion: @escaping (Data) -> Void) {
        let url = URL(string: "\(Routes.baseurl)\(endpoint)")!
        var req = URLRequest(url: url)
        req.httpMethod = HttpMethod.rawValue
        URLSession.shared.dataTask(with: req) { data, resonse, error in
            if error != nil {
                return
            }
            if let data = data {
                completion(data)
                
            }
        }.resume()
    }
}
