//
//  NetworkService.swift
//  Sharmanka
//
//  Created by Vadym Potapov on 12.01.2023.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTracks(searchText: String, completion: @escaping (SearchResponce?) -> Void) {
        
        let url = "https://itunes.apple.com./search"
        let parameters = ["term": "\(searchText)",
                          "limit": "10",
                          "media": "music"
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { dataResponse in
            if let error = dataResponse.error {
                print("Error recive requestion data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = dataResponse.data else { return }
            let decoder = JSONDecoder()
            
            do {
                let object = try decoder.decode(SearchResponce.self, from: data)
                print("object:", object)
                completion(object)
                
            } catch let jsonError {
                print("Decoder fail json", jsonError)
                completion(nil)
            }
            
//            let someString = String(data: data, encoding: .utf8)
//            print(someString ?? "")
        }
    }
}
