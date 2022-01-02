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
        var urlParameterAdded = false
        var url = NetworkingUrls.cat_Service_Base_Url
        if let tag = options.tag {
            url += "/\(tag)"
        }
        
        //adding condition on bool for readability
        if let gif = options.gif, gif == true {
            url += "/gif"
        }
        
        if let says = options.says {
            url += "/says/\(says)"
            if options.size != nil || options.color != nil {
                url += "?"
                if let size = options.size {
                         url += "size=\(size)"
                    urlParameterAdded = true
                     }
                   if let color = options.color {
                    url += "\(urlParameterAdded ? "&" : "")color=\(color)"
                    urlParameterAdded = true
                   }
            }
        }
        
        if let type = options.type {
          url += "\(urlParameterAdded ? "&" : "")type=\(type)"
          urlParameterAdded = true
         }
        
        if let filter = options.filter {
          url += "\(urlParameterAdded ? "&" : "")filter=\(filter)"
          urlParameterAdded = true
         }
        
        if let width = options.width {
          url += "\(urlParameterAdded ? "&" : "")width=\(width)"
          urlParameterAdded = true
         }
        
        if let height = options.height {
          url += "\(urlParameterAdded ? "&" : "")height=\(height)"
          urlParameterAdded = true
         }
        
        return NSString(string: url).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? NetworkingUrls.cat_Service_Base_Url
    }
}
