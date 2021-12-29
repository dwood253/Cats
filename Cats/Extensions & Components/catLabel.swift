//
//  catLabel.swift
//  Cats
//
//  Created by Daniel Wood on 12/28/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit

class catLabel: UILabel {
    init(text: String? = "", fontSize: Int16 = 10, textColor: UIColor = .black) {
        super.init(frame: CGRect.zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
