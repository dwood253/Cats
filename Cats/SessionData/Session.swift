//
//  Session.swift
//  Cats
//
//  Created by Daniel Wood on 12/29/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import Foundation

fileprivate let OPTIONS_KEY = "options_key"

class Session {
    static let data = Session()
    var options: OptionsModel! {
        didSet {
            storeOptions()
        }
    }
    var encoder = JSONEncoder()
    var decoder = JSONDecoder()
    
    init() {
        options = getOptions()
    }
    
    func getOptions() -> OptionsModel {
        let defaults = UserDefaults.standard
        if let data = defaults.value(forKey: OPTIONS_KEY) as? Data, let optionsDecoded = try? decoder.decode(OptionsModel.self, from: data) {
            return optionsDecoded
        } else {
            return OptionsModel()
        }
        
    }
    
    func storeOptions() {
        guard let options = self.options else { return }
        let defaults = UserDefaults.standard
        if let encoded = try? encoder.encode(options) {
            defaults.set(encoded, forKey: OPTIONS_KEY)
        }
    }
    
    func getUrl() -> String {
        var url = NetworkingUrls.cat_Service_Base_Url
//        if options.
        return url
    }
}
