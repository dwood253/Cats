//
//  OptionTextVCViewController.swift
//  Cats
//
//  Created by Daniel Wood on 12/28/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit

class OptionContainerVC: UIViewController {
//    lazy var checkBox = CheckBox(checked: false)
    lazy var checkBox: CheckBox = {
        let cb = CheckBox(checked: false)
        return cb
    }()
    
    lazy var optionLabel: UILabel = {
       let tf = UILabel()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: Constants.labelHeight).isActive = true
        tf.layer.cornerRadius = Constants.fieldCornerRadius
        return tf
    }()
    
    convenience init(labelText: String) {
        self.init()
        self.optionLabel.text = labelText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.view.addSubviews([checkBox.view, optionLabel])
        self.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkBox.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.checkBoxSideMargin),
            checkBox.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            optionLabel.leadingAnchor.constraint(equalTo: checkBox.view.trailingAnchor, constant: Constants.checkBoxSideMargin),
            optionLabel.centerYAnchor.constraint(equalTo: checkBox.view.centerYAnchor)
        ])
    }

}

extension OptionContainerVC: OptionSelected {
    func isSelected() -> Bool {
        return false
    }
    
    
}
