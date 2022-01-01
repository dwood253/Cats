//
//  catTextField.swift
//  Cats
//
//  Created by Daniel Wood on 1/1/22.
//  Copyright © 2022 Daniel Wood. All rights reserved.
//

import UIKit

class catTextField: UITextField {
    var numbersOnly: Bool = false
    
    init(initialValue: String? = "", numbersOnly: Bool = false, alignment: NSTextAlignment = .left) {
        super.init(frame: CGRect.zero)
        self.text = initialValue
        self.layer.cornerRadius = Constants.field_corner_radius
        self.numbersOnly = numbersOnly
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = alignment
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
        print(text)
        return super.shouldChangeText(in: range, replacementText: text)
    }
    
}
