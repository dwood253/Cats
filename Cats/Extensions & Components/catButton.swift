//
//  catButton.swift
//  Cats
//
//  Created by Daniel Wood on 12/31/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit

class catButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = Constants.button_corner_radius
        self.backgroundColor = Constants.button_color
        self.setTitleColor(Constants.button_title_color, for: .normal)
        self.titleLabel!.font = UIFont.systemFont(ofSize: Constants.button_title_font_size, weight: .semibold)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
