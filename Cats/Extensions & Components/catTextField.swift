//
//  catTextField.swift
//  Cats
//
//  Created by Daniel Wood on 1/1/22.
//  Copyright © 2022 Daniel Wood. All rights reserved.
//

import UIKit

class catTextField: UITextField, UITextFieldDelegate {
    var numbersOnly: Bool = false
    
    init(initialValue: String? = "", numbersOnly: Bool = false, alignment: NSTextAlignment = .left) {
        super.init(frame: CGRect.zero)
        self.text = initialValue
        self.layer.cornerRadius = Constants.field_corner_radius
        self.numbersOnly = numbersOnly
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = alignment
        self.delegate = self
        if self.numbersOnly {
            self.keyboardType = .numberPad
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDoneButton() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneEditing))
        toolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolbar
    }
    
    @objc func doneEditing() {
        self.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.numbersOnly {
            return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        } else {
            return CharacterSet.alphanumerics.isSuperset(of: CharacterSet(charactersIn: string))
        }
    }
}
