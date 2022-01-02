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

fileprivate let RETRY_COUNT = 5
fileprivate let THROTTILING_MESSSAGE = "Failed to get a new cat. Try changing some options. Maybe be a furball in the network, or the API May be throttling..."

class NetworkingManager {
    static let shared = NetworkingManager()
    static let jsonDecoder = JSONDecoder()
    var previouslyFetchedData: Data?
    init() {
    }
    
    func getCat(url: String, completion: @escaping(Result<UIImage, nmError>) -> Void ) {
        giveMeACatRetry(url: url, numberOfAttempts: 0) { (image) in
            if let catImage = image {
                completion(.success(catImage))
            } else {
                completion(.failure(nmError(THROTTILING_MESSSAGE)))
            }
        }
    }
    
    func giveMeACatRetry(url: String, numberOfAttempts: Int,  completion: @escaping(UIImage?) -> Void) {
        print("numberofattempts: \(numberOfAttempts)")
        if numberOfAttempts < RETRY_COUNT {
            AF.request(url).response { response in
                if let data = response.data, let catImage = UIImage(data: data) {
                    if let oldImageData = NetworkingManager.shared.previouslyFetchedData, oldImageData == data {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.giveMeACatRetry(url: url, numberOfAttempts: numberOfAttempts + 1) { (newImage) in
                                completion(newImage)
                            }
                        }
                    } else {
                        NetworkingManager.shared.previouslyFetchedData = data
                        completion(catImage)
                    }
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
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
