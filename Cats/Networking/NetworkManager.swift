//
//  NetworkManager.swift
//  Cats
//
//  Created by Daniel Wood on 12/22/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class NetworkingManager {
    static let shared = NetworkingManager()
    static let jsonDecoder = JSONDecoder()
    
    init() {
    }
    
    func getCat(url: String, completion: @escaping(Result<UIImage, Error>) -> Void ) {
        AF.request(url).response { response in
            if let data = response.data, let catImage = UIImage(data: data) {
                completion(.success(catImage))
            } else {
                completion(.failure(nmError("Failed to get Random Can Image")))
            }
        }
    }
    
    func getAvailableTags(completion: @escaping(Result<[String], Error>) -> Void ) {
        AF.request(NetworkingUrls.available_Tags, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                guard let tags = data as? [String] else { completion(.failure(nmError("Failed to parse tags"))); return }
                completion(.success(tags))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class nmError: Error {
    var error: String
    init(_ message: String) {
        self.error = message
    }
}
