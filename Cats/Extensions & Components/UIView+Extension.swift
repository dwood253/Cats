//
//  UIViewControler+Extension.swift
//  Cats
//
//  Created by Daniel Wood on 12/22/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//


import UIKit

extension UIView {
    
    func fillSuperView(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        guard let parent = self.superview else { return }
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top),
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -insets.right),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    func addSubviews(_ subviews: [UIView]) {
        for view in subviews {
            self.addSubview(view)
        }
    }
}

