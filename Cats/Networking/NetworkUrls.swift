//
//  NetworkUrls.swift
//  Cats
//
//  Created by Daniel Wood on 12/22/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import Foundation

fileprivate let SAMPLE_CAT_ID = "595f280c557291a9750ebf80"

struct NetworkingUrls {
    static let cat_Service_Base_Url = "https://cataas.com/cat"
    static let cat_Service_API_Base = "https://cataas.com/api/"
    static let available_Tags = cat_Service_API_Base + "tags"
    static let filter_Sample_Cat = cat_Service_Base_Url + "/\(SAMPLE_CAT_ID)?filter="
    //https://cataas.com/cat/595f280c557291a9750ebf80?filter=sepia
}
