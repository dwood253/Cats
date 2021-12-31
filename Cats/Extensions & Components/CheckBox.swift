//
//  CheckBox.swift
//  Cats
//
//  Created by Daniel Wood on 12/28/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit

fileprivate let unCheckedImageName = "square"
fileprivate let checkedImageName = "square.fill"
fileprivate let dimension: CGFloat = 15
fileprivate let CHECK_TOGGLE_DURATION = 0.2

class CheckBox: UIViewController {
    lazy var button: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    var isChecked: Bool = false {
        didSet {
            setImage()
        }
    }
    var delegate: OptionSelectedDelegate!
    var key: OptionType!
    
    convenience init(checked: Bool) {
        self.init()
        self.isChecked = checked
        self.delegate = delegate
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        self.button.addTarget(self, action: #selector(toggleChecked), for: .touchUpInside)
    }
    
    func setupUI() {
        self.view.addSubview(button)
        button.fillSuperView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.view.heightAnchor.constraint(equalToConstant: dimension),
            self.view.widthAnchor.constraint(equalToConstant: dimension),
        ])
        setImage()
    }
    
    func setImage() {
        let imageName = self.isChecked ? checkedImageName : unCheckedImageName
        UIView.transition(with: self.button, duration: CHECK_TOGGLE_DURATION, options: .transitionCrossDissolve, animations: {
            self.button.setImage(UIImage(systemName: imageName), for: .normal)
        }, completion: nil)
    }
    
    @objc func toggleChecked() {
        isChecked.toggle()
        delegate.selectionChanged(key: key, selected: isChecked)
    }
}
