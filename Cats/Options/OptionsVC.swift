//
//  optionsVC.swift
//  Cats
//
//  Created by Daniel Wood on 12/28/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit
fileprivate let OPTION_CELL_ID = "option_cell_id"


protocol OptionSelectedDelegate {
    func selectionChanged(key: OptionType, selected: Bool)
}

class OptionsVC: UINavigationController {
    
    lazy var optionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var optionViews: [UIView] = []
    
    lazy var tagOption: OptionContainerVC = {
        let option = OptionContainerVC(labelText: "Tag", optionKey: .Tag, delegate: self)
        return option
    }()
    let tagButton = UIButton()
    
    var availableTags: [String]?
    
    lazy var gifOption: OptionContainerVC = {
        let option = OptionContainerVC(labelText: "Gif", optionKey: .Gif, delegate: self)
        return option
    }()
    
    lazy var saysOption: OptionContainerVC = {
        let option = OptionContainerVC(labelText: "Says", optionKey: .Says, delegate: self)
        return option
    }()
    lazy var saysButton = UIButton()
    lazy var sizeButton = UIButton()
    lazy var colorButton = UIButton()
    
    lazy var typeOption: OptionContainerVC = {
        let option = OptionContainerVC(labelText: "Type", optionKey: .SizeType, delegate: self)
        return option
    }()
    
    lazy var typeButton = UIButton()
    
    lazy var filterOption: OptionContainerVC = {
        let option = OptionContainerVC(labelText: "Filter", optionKey: .Filter, delegate: self)
        return option
    }()
    
    lazy var filterButton: UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var widthOption: OptionContainerVC = {
        let option = OptionContainerVC(labelText: "Width", optionKey: .Width, delegate: self)
        return option
    }()
    
    lazy var widthButton = UIButton()
    
    lazy var heightOption: OptionContainerVC = {
        let option = OptionContainerVC(labelText: "Height", optionKey: .Height, delegate: self)
        return option
    }()
    
    lazy var heightButton = UIButton()
    
    
    var dataGroup = DispatchGroup()
    var cachedOptions = Session.data.options
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupOptions()
        getData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Setup UI
    fileprivate func setupUI() {
        self.view.addSubview(optionCollectionView)
        optionCollectionView.fillSuperView()
        optionCollectionView.delegate = self
        optionCollectionView.dataSource = self
        optionCollectionView.register(OptionCollectionViewCell.self, forCellWithReuseIdentifier: OPTION_CELL_ID)
        optionCollectionView.backgroundColor = .secondarySystemGroupedBackground
    }
    
    //MARK: - Options
    fileprivate func setupOptions() {
        guard let options = Session.data.options else { return }
        //tag
        optionViews.append(setupTagOption(tag: options.tag))
        //gif
        gifOption.checkBox.isChecked = (cachedOptions?.gif ?? false) ? true : false
        optionViews.append(gifOption.view)
        //says
        optionViews.append(setupSaysOption(says: options.says, size: options.size, color: options.color))
        //size type
        optionViews.append(setupTypeOption(sizeType: options.type))
        //filter
        optionViews.append(setupFilterOption(filter: options.filter))
        //width
        optionViews.append(setupWidthOption(selected: options.width != nil, buttonText: options.width ?? "300" ))
        //width
        optionViews.append(setupHeightOption(selected: options.height != nil, buttonText: options.height ?? "300"))

    }
    
    func setupTagOption(tag: String?) -> UIView {
        setupOptionWithButton(option: tagOption, selected: tag != nil, button: tagButton, buttonText: tag ?? "", selector: #selector(showTagSelectorView))
        return tagOption.view
    }
    
    
    fileprivate func setupSaysOption(says: String?, size: String?, color: String?) -> UIView{
        setupOptionWithButton(option: saysOption, selected: says != nil, button: saysButton, buttonText: says ?? "Hello, World!", selector: #selector(showSaysInputView))
        
        let size = size ?? "30"
        let color = color ?? "White"
        sizeButton.setTitle("Size: \(size)", for: .normal)
        colorButton.setTitle("Color: \(color)", for: .normal)
        if let sizeButtonLabel = sizeButton.titleLabel, let colorButtonLabel = colorButton.titleLabel {
            sizeButtonLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            colorButtonLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        }
        sizeButton.setTitleColor(.link, for: .normal)
        colorButton.setTitleColor(.link, for: .normal)
        sizeButton.translatesAutoresizingMaskIntoConstraints = false
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        saysOption.view.addSubviews([sizeButton, colorButton])
        NSLayoutConstraint.activate([
            colorButton.trailingAnchor.constraint(equalTo: saysOption.view.trailingAnchor, constant:  -Constants.option_padding_right),
            colorButton.topAnchor.constraint(equalTo: saysOption.optionLabel.bottomAnchor, constant: 5),
            sizeButton.centerYAnchor.constraint(equalTo: colorButton.centerYAnchor),
            sizeButton.trailingAnchor.constraint(equalTo: colorButton.leadingAnchor, constant: -10),
            saysOption.view.bottomAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: 5)
        ])
        sizeButton.addTarget(self, action: #selector(showSizeInputView), for: .touchUpInside)
        colorButton.addTarget(self, action: #selector(showColorSelectView), for: .touchUpInside)
        
        return saysOption.view
    }
    
    fileprivate func setupTypeOption(sizeType: String?) -> UIView{
        setupOptionWithButton(option: typeOption, selected: sizeType != nil, button: typeButton, buttonText: sizeType ?? "original", selector: #selector(showTypeInputView))
        return typeOption.view
    }
    
    fileprivate func setupFilterOption(filter: String?) -> UIView{
        setupOptionWithButton(option: filterOption, selected: filter != nil, button: filterButton, buttonText: filter ?? Constants.filters[0], selector: #selector(showFilterSelectorView))
        return filterOption.view
    }
    
    fileprivate func setupWidthOption(selected: Bool, buttonText: String) -> UIView{
        setupOptionWithButton(option: widthOption, selected: selected, button: widthButton, buttonText: buttonText, selector: #selector(showWidthInputView))
        return widthOption.view
    }
    
    fileprivate func setupHeightOption(selected: Bool, buttonText: String) -> UIView{
        setupOptionWithButton(option: heightOption, selected: selected, button: heightButton, buttonText: buttonText, selector: #selector(showHeightInputView))
        return heightOption.view
    }
    
    fileprivate func setupOptionWithButton(option: OptionContainerVC, selected: Bool, button: UIButton, buttonText: String, selector: Selector) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitle(buttonText, for: .normal)
        option.view.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: option.optionLabel.trailingAnchor),
            button.centerYAnchor.constraint(equalTo: option.optionLabel.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: option.view.trailingAnchor, constant: -Constants.option_padding_right),
            button.heightAnchor.constraint(equalToConstant: Constants.label_height)
        ])
        option.checkBox.isChecked = selected
    }
    
    //MARK: - Data
    func getData() {
        self.showLoadingView()
        getAvailableTags()
        dataGroup.notify(queue: .main) {
            if let options = Session.data.options {
                if let tag = options.tag, self.availableTags?.contains(tag) ?? false {
                    self.tagButton.setTitle(tag, for: .normal)
                } else {
                    //cached tag is no longer available or no tag cached
                    options.tag = nil
                    self.tagButton.setTitle(self.availableTags?[0] ?? "", for: .normal)
                    Session.data.storeOptions()
                }
            }
            self.dismissLoadingView()
        }
    }
    	
    func getAvailableTags() {
        dataGroup.enter()
        NetworkingManager.shared.getAvailableTags { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let tags):
                self.availableTags = tags
                //remove unecessary empty tag
                if let first = self.availableTags?[0], first.isEmpty {
                    self.availableTags?.remove(at: 0)
                }
            case .failure(_):
                //TODO: handle oopsie...
                break
            }
            self.dataGroup.leave()
        }
    }
    
    //MARK: - Helpers
    @objc func showTagSelectorView() {
        let tagSelector = OptionSelectorVCViewController(optionType: .Tag, options: availableTags ?? [], delegate: self)
        tagSelector.modalPresentationStyle = .overFullScreen
        self.present(tagSelector, animated: true, completion: nil)
    }
    
    @objc func showFilterSelectorView() {
        let selector = FilterSelectorTVC(delegate: self)
        selector.modalPresentationStyle = .overFullScreen
        self.present(selector, animated: true, completion: nil)
    }
    
    @objc func showSaysInputView() {
        let inputView = OptionInputVC(inputTitles: ["Caption Text"], inputValues: [saysButton.titleLabel?.text ?? ""], type: .Says, delegate: self, optionalTag: 0)
        inputView.modalPresentationStyle = .overFullScreen
        self.present(inputView, animated: true, completion: nil)
    }
    
    @objc func showSizeInputView() {
        let saysSize = Session.data.options.size ?? "30"
        let inputView = OptionInputVC(inputTitles: ["Says Text Size"], inputValues: [saysSize], numbersOnly: true, type: .Says, delegate: self, optionalTag: 1)
        inputView.modalPresentationStyle = .overFullScreen
        self.present(inputView, animated: true, completion: nil)
    }
    
    @objc func showColorSelectView() {
         let selector = OptionSelectorVCViewController(optionType: .Says, options: Constants.colors, delegate: self)
         selector.modalPresentationStyle = .overFullScreen
         self.present(selector, animated: true, completion: nil)
     }
    
    @objc func showTypeInputView() {
        let typeSelector = OptionSelectorVCViewController(optionType: .SizeType, options: Constants.types, delegate: self)
        typeSelector.modalPresentationStyle = .overFullScreen
        self.present(typeSelector, animated: true, completion: nil)
    }
    
    @objc func showWidthInputView() {
        guard let options = Session.data.options else { return }
        let inputView = OptionInputVC(inputTitles: ["Width"], inputValues: [options.width ?? "300"], numbersOnly: true, type: .Width, delegate: self)
        inputView.modalPresentationStyle = .overFullScreen
        self.present(inputView, animated: true, completion: nil)
    }
    
    @objc func showHeightInputView() {
        guard let options = Session.data.options else { return }
        let inputView = OptionInputVC(inputTitles: ["Height"], inputValues: [options.height ?? "300"], numbersOnly: true, type: .Height, delegate: self)
        inputView.modalPresentationStyle = .overFullScreen
        self.present(inputView, animated: true, completion: nil)
    }
}


//MARK: - CollectionView
extension OptionsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OPTION_CELL_ID, for: indexPath) as! OptionCollectionViewCell
        cell.option = optionViews[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowHeight: CGFloat = indexPath.row == 2 ? 60 : 30
        return CGSize(width:  CGFloat(min(self.view.frame.size.height, self.view.frame.size.width)), height: rowHeight)
    }
}


//MARK: - OptionSelectedDelegate - Called when checkbox value changes
extension OptionsVC: OptionSelectedDelegate {
    func selectionChanged(key: OptionType, selected: Bool) {
        guard let options = Session.data.options else { return }
        switch key {
        case .Tag:
            options.tag = selected ? tagButton.titleLabel?.text ?? "" : nil
        case .Gif:
            options.gif = selected
        case .Says:
            options.says = selected ? saysButton.titleLabel?.text ?? "" : nil
        case .SizeType:
            options.type = selected ? typeButton.titleLabel?.text ?? "" : nil
        case .Filter:
            options.filter = selected ? filterButton.titleLabel?.text ?? "" : nil
        case .Width:
            options.width = selected ? widthButton.titleLabel?.text ?? "" : nil
        case .Height:
            options.height = selected ? heightButton.titleLabel?.text ?? "" : nil
        }
        Session.data.storeOptions()
    }
}

//MARK: - OptionValueChangedDelegate - Called when Tag or Filter tableview option selected
extension OptionsVC: OptionValueChangedDelegate {
    func optionValueChanged(optionValue: String, optionType: OptionType) {
        guard let options = Session.data.options else { return }
        
        switch optionType {
        case .Tag:
            options.tag = optionValue
            tagButton.setTitle(optionValue, for: .normal)
            tagOption.checkBox.isChecked = true
        case .Filter:
            options.filter = optionValue
            filterButton.setTitle(optionValue, for: .normal)
            filterOption.checkBox.isChecked = true
        case .SizeType:
            options.type = optionValue
            typeButton.setTitle(optionValue, for: .normal)
            typeOption.checkBox.isChecked = true
        case .Says:
            options.color = optionValue
            colorButton.setTitle("Color: \(optionValue)", for: .normal)
        default:
            break
        }
        
        Session.data.storeOptions()
    }
}

//MARK: - OptionsInputDelegate - Called when Options that require user input changed
extension OptionsVC: OptionsInputDelegate {
    func finishedChangingOption(fieldValues: [String], option: OptionType, optionalTag: Int?) {
        guard let options = Session.data.options else { return }
        switch option {
        case .Says:
            guard let optionalTag = optionalTag else { return }
            switch optionalTag{
            case 0:
                options.says = !fieldValues.isEmpty ? fieldValues[0] : nil
                saysButton.setTitle(options.says ?? "Hello, World!", for: .normal)
                saysOption.checkBox.isChecked = true
            case 1:
                options.size = !fieldValues.isEmpty ? fieldValues[0] : nil
                sizeButton.setTitle("Size: \(options.size ?? "30")", for: .normal)
            default:
                break
            }

        case .Width:
            options.width = fieldValues.isEmpty ? nil : fieldValues[0]
            widthButton.setTitle(fieldValues.isEmpty ? "300" : fieldValues[0], for: .normal)
            widthOption.checkBox.isChecked = true
        case .Height:
            options.height = fieldValues.isEmpty ? nil : fieldValues[0]
            heightButton.setTitle(fieldValues.isEmpty ? "300" : fieldValues[0], for: .normal)
            heightOption.checkBox.isChecked = true
        default:
            break
        }
        Session.data.storeOptions()
    }
}


//MARK: - UICollectionViewCell
class OptionCollectionViewCell: UICollectionViewCell {
    var option: UIView? {
        didSet {
            guard let view = option else { return }
            self.addSubview(view)
            view.fillSuperView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum OptionType {
    case Tag
    case Gif
    case Says
    case SizeType
    case Filter
    case Width
    case Height
}


