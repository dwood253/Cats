//
//  UIViewControler+Extension.swift
//  Cats
//
//  Created by Daniel Wood on 12/22/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//


import UIKit

extension UIViewController {
    func fillSuperView(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        guard let parentView = self.parent?.view else { return }
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: parentView.topAnchor, constant: insets.top),
            self.view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: insets.left),
            self.view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -insets.right),
            self.view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -insets.bottom)
        ])
    }
}

