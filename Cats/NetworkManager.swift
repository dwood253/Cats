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
    
    func fetchRandomCat(completion: @escaping (Result<UIImage, Error>) -> Void ) {
        AF.request(NetworkingUrls.random_Cat).response { response in
            if let data = response.data, let catImage = UIImage(data: data) {
                completion(.success(catImage))
            } else {
                completion(.failure(nmError(message: "Failed to get Random Can Image")))
            }
        }
    }
    
    func getSpecificCat(url: String, completion: @escaping(Result<UIImage, Error>) -> Void ) {
        AF.request(url).response { response in
            if let data = response.data, let catImage = UIImage(data: data) {
                completion(.success(catImage))
            } else {
                completion(.failure(nmError(message: "Failed to get Random Can Image")))
            }
        }
    }
}

class nmError: Error {
    var error: String
    init(message: String) {
        self.error = message
    }
}
