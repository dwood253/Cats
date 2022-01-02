//
//  OptionsModel.swift
//  Cats
//
//  Created by Daniel Wood on 12/29/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import Foundation
class OptionsModel: Codable {
    var tag: String?
    var gif: Bool?
    var says: String?
    var size: String?
    var color: String?
    var filter: String?
    var width_height: Bool?
    var width: String = "300"
    var height: String = "300"
}
