//
//  optionsVC.swift
//  Cats
//
//  Created by Daniel Wood on 12/28/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit
fileprivate let OPTION_CELL_ID = "option_cell_id"

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
    let filters = ["blur", "mono", "sepia", "negative", "paint", "pixel"]
    
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
    
    
    fileprivate func setupUI() {
        self.view.addSubview(optionCollectionView)
        optionCollectionView.fillSuperView()
        optionCollectionView.delegate = self
        optionCollectionView.dataSource = self
        optionCollectionView.register(OptionCollectionViewCell.self, forCellWithReuseIdentifier: OPTION_CELL_ID)
        optionCollectionView.backgroundColor = .secondarySystemGroupedBackground
    }
    
    func setupOptions() {
        guard let options = Session.data.options else { return }
        optionViews.append(setupTagOption(tag: options.tag))
        gifOption.checkBox.isChecked = (cachedOptions?.gif ?? false) ? true : false
        optionViews.append(gifOption.view)
    }

    
    func setupTagOption(tag: String?) -> UIView {
        tagButton.translatesAutoresizingMaskIntoConstraints = false
        tagButton.addTarget(self, action: #selector(showTagSelectorView), for: .touchUpInside)
        tagButton.setTitleColor(.link, for: .normal)
        tagButton.titleLabel?.font = .systemFont(ofSize: 14)
        tagOption.view.addSubview(tagButton)
        NSLayoutConstraint.activate([
            tagButton.leadingAnchor.constraint(equalTo: tagOption.optionLabel.trailingAnchor),
            tagButton.centerYAnchor.constraint(equalTo: tagOption.optionLabel.centerYAnchor),
            tagButton.trailingAnchor.constraint(equalTo: tagOption.view.trailingAnchor, constant: -Constants.option_padding_right),
            tagButton.heightAnchor.constraint(equalToConstant: Constants.labelHeight)
        ])
        if let tag = tag, !tag.isEmpty {
            tagOption.checkBox.isChecked = true
            tagButton.setTitle(tag, for: .normal)
        }
        return tagOption.view
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
    
    //MARK - Helpers
    @objc func showTagSelectorView() {
        let tagSelector = TagSelectorVCViewController()
        tagSelector.delegate = self
        tagSelector.tagOptions = availableTags ?? []
        tagSelector.modalPresentationStyle = .overFullScreen
        self.present(tagSelector, animated: true, completion: nil)
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
        return CGSize(width:  CGFloat(min(self.view.frame.size.height, self.view.frame.size.width)), height: 30)
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

//MARK: PickerView
extension OptionsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableTags?[row] ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let options = Session.data.options else { return }

        Session.data.storeOptions()
    }
}

extension OptionsVC: OptionSelectedDelegate {
    func selectionChanged(key: OptionKey, selected: Bool) {
        guard let options = Session.data.options else { return }
        switch key {
        case .Tag:
            options.tag = selected ? tagButton.titleLabel?.text ?? "" : nil
        case .Gif:
            options.gif = selected
        case .Says:
            break
        case .Size:
            break
        case .Filter:
            break
        case .Width_Height:
            break
        }
        Session.data.storeOptions()
    }
}

extension OptionsVC: TagSelectedDelegate {
    func tagSelected(tag: String) {
        guard let options = Session.data.options else { return }
        options.tag = tag
        tagButton.setTitle(tag, for: .normal)
        tagOption.checkBox.isChecked = true
        Session.data.storeOptions()
    }
}

protocol OptionSelectedDelegate {
    func selectionChanged(key: OptionKey, selected: Bool)
}

enum OptionKey {
    case Tag
    case Gif
    case Says
    case Size
    case Filter
    case Width_Height
}


