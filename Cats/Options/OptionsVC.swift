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
    
    lazy var options: [UIView] = []
    
    lazy var tagOption: OptionContainerVC = {
        let option = OptionContainerVC(labelText: "Tag")
        return option
    }()
    
    var availableTags: [String]?
    
    lazy var gifOption: OptionContainerVC = {
        let option = OptionContainerVC(labelText: "Gif")
        return option
    }()
    
    var dataGroup = DispatchGroup()
    
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
        options.append(setupTagOption())
        options.append(gifOption.view)
    }

    
    func setupTagOption() -> UIView {
        
        return tagOption.view
    }
    
    //MARK: - Data
    func getData() {
        self.showLoadingView()
        getAvailableTags()
        dataGroup.notify(queue: .main) {
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
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OPTION_CELL_ID, for: indexPath) as! OptionCollectionViewCell
        cell.option = options[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  CGFloat(min(self.view.frame.size.height, self.view.frame.size.width)), height: 30)
    }
}

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


protocol OptionSelected {
    func isSelected() -> Bool
}


