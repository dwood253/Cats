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
    let tagPicker = UIPickerView()
    let tagTextView = UITextView()
    
    var availableTags: [String]?
    
    lazy var gifOption: OptionContainerVC = {
        let option = OptionContainerVC(labelText: "Gif", optionKey: .Gif, delegate: self)
        return option
    }()
    
    var dataGroup = DispatchGroup()
    var cachedOptions = Session.data.options
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupOptions()
        getData()
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
        tagPicker.delegate = self
        tagPicker.dataSource = self
        tagTextView.translatesAutoresizingMaskIntoConstraints = false
        tagTextView.inputView = tagPicker
        tagTextView.textColor = .link
        tagTextView.font = .systemFont(ofSize: 14)
        tagTextView.text = "(none)"
        tagTextView.tintColor = .clear
        tagOption.view.addSubview(tagTextView)
        NSLayoutConstraint.activate([
            tagTextView.leadingAnchor.constraint(equalTo: tagOption.optionLabel.trailingAnchor),
            tagTextView.centerYAnchor.constraint(equalTo: tagOption.optionLabel.centerYAnchor),
            tagTextView.trailingAnchor.constraint(equalTo: tagOption.view.trailingAnchor),
            tagTextView.heightAnchor.constraint(equalToConstant: Constants.labelHeight)
        ])
        if let tag = tag, !tag.isEmpty {
            tagOption.checkBox.isChecked = true
            tagTextView.text = tag
        }
        return tagOption.view
    }
    
    //MARK: - Data
    func getData() {
        self.showLoadingView()
        getAvailableTags()
        dataGroup.notify(queue: .main) {
            if let options = Session.data.options {
                if let tag = options.tag, let selectedIndex = self.availableTags?.firstIndex(of: tag) {
                    self.tagPicker.selectRow(selectedIndex, inComponent: 0, animated: false)
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
            case .failure(_):
                //TODO: handle oopsie...
                break
            }
            self.dataGroup.leave()
        }
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
        case tagPicker:
            return availableTags?.count ?? 0
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableTags?[row] ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let options = Session.data.options else { return }
        if row > 0 {
            self.tagOption.checkBox.isChecked = true
            self.tagTextView.text = availableTags![row]
            options.tag = availableTags![row]
        } else {
            self.tagOption.checkBox.isChecked = false
            self.tagTextView.text = "(none)"
            options.tag = nil
        }
        self.tagTextView.resignFirstResponder()
        Session.data.storeOptions()
    }
}

extension OptionsVC: OptionSelectedDelegate {
    func selectionChanged(key: OptionKey, selected: Bool) {
        guard let options = Session.data.options else { return }
        switch key {
        case .Tag:
            if tagTextView.text.elementsEqual("(none)") {
                self.tagTextView.becomeFirstResponder()
            } else {
                options.tag = tagTextView.text
            }
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


