//
//  NetworkUrls.swift
//  Cats
//
//  Created by Daniel Wood on 12/22/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import Foundation

struct NetworkingUrls {
    static let cat_Service_Base_Url = "https://cataas.com/"
    static let api_SubDirectory = "api/"
    static let api_call_base = cat_Service_Base_Url + api_SubDirectory
    static let random_Cat = cat_Service_Base_Url + "cat"
}
