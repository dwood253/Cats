//
//  optionInputVC.swift
//  Cats
//
//  Created by Daniel Wood on 12/31/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit

protocol OptionsInputDelegate {
    func finishedChangingOption(fieldValues:[String], option: OptionType)
}

class OptionInputVC: UIViewController {
    var inputTitles: [String] = []
    var inputValues: [String] = []
    var numbersOnly: Bool = false
    var optionType: OptionType!
    var delegate: OptionsInputDelegate?
    
    lazy var valueStack: UIStackView = {
       let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var doneButton: catButton = {
        let btn = catButton()
        btn.setTitle("Done", for: .normal)
        btn.addTarget(self, action: #selector(validateAndSubmit), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancelButton: catButton = {
        let btn = catButton()
        btn.setTitle("Cancel", for: .normal)
        btn.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Lifecycle
    convenience init(inputTitles: [String], inputValues:[String], numbersOnly: Bool = false, type: OptionType, delegate: OptionsInputDelegate) {
        self.init()
        self.inputTitles = inputTitles
        self.inputValues = inputValues
        self.numbersOnly = numbersOnly
        self.optionType = type
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addOptionFields()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.secondarySystemGroupedBackground.withAlphaComponent(0.8)
        self.view.addSubviews([valueStack, doneButton, cancelButton])
        NSLayoutConstraint.activate([
            valueStack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            valueStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            valueStack.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.button_padding),
            cancelButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -(Constants.button_padding/2)),
            cancelButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.button_padding),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.button_height),

            doneButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            doneButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: Constants.button_padding),
            doneButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.button_padding),
            doneButton.heightAnchor.constraint(equalToConstant: Constants.button_height),
        ])
    }
    
    func addOptionFields() {
        for i in 0..<inputTitles.count {
            let label = catLabel(text: inputTitles[i], alignment: .center)
            let inputField = catTextField(initialValue: inputValues[i], numbersOnly: self.numbersOnly, alignment: .center)
            inputField.backgroundColor = .secondarySystemBackground	
            inputField.tag = i
            let container = UIView()
            container.addSubviews([label, inputField])
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.label_padding),
                label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                label.heightAnchor.constraint(equalToConstant: Constants.label_height),
                
                inputField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Constants.label_padding),
                inputField.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                inputField.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: Constants.text_margin),
                inputField.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -Constants.text_margin),
                inputField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.text_margin)
            ])
            valueStack.addArrangedSubview(container)
        }
    }
    
    @objc func validateAndSubmit() {
        
    }
    
    @objc func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
}
