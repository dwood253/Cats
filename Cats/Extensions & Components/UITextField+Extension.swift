//
//  UITextField+Extension.swift
//  Cats
//
//  Created by Daniel Wood on 12/30/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit
extension UITextField {
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
