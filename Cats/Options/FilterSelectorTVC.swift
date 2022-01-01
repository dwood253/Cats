//
//  FilterSelectorTVC.swift
//  Cats
//
//  Created by Daniel Wood on 12/31/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit

fileprivate let FILTER_CELL_ID = "filter_cell_id"
class FilterSelectorTVC: UIViewController {
    
    convenience init(delegate: OptionValueChangedDelegate ) {
        self.init()
        self.delegate = delegate
    }
    
    lazy var filterExampleTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
   
    lazy var cancelButton: catButton = {
        let btn = catButton()
        btn.setTitle("Dismiss", for: .normal)
        btn.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return btn
    }()
    
    var delegate: OptionValueChangedDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubviewToFront(cancelButton)
    }
    
    //MARK: - setupUI
    func setupUI() {
        filterExampleTable.delegate = self
        filterExampleTable.dataSource = self
        filterExampleTable.estimatedRowHeight = 166
        filterExampleTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        filterExampleTable.backgroundColor = .secondarySystemGroupedBackground
        filterExampleTable.register(FilterSelectorTVCell.self, forCellReuseIdentifier: FILTER_CELL_ID)
        view.addSubview(filterExampleTable)
        filterExampleTable.fillSuperView()
        
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.button_height),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])

    }
    
    
    //MARK: - Helpers
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
}

 // MARK: - UITableView
extension FilterSelectorTVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textAlignment = .center
        headerLabel.text = Constants.filters[section].uppercased()
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = .secondarySystemGroupedBackground
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 30),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FILTER_CELL_ID, for: indexPath) as! FilterSelectorTVCell
        let url = NetworkingUrls.filter_Sample_Cat + Constants.filters[indexPath.section]
        NetworkingManager.shared.getCat(url: url) { result in
            switch result {
            case .success(let cat):
                cell.setImage(catImage: cat)
            case .failure(_):
                //TODO: handle this error?
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 166
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let optionDelegate = self.delegate {
            optionDelegate.optionValueChanged(optionValue: Constants.filters[indexPath.section], optionType: .Filter)
            dismissSelf()
        }
    }
}

class FilterSelectorTVCell: UITableViewCell {
    lazy var placeholderView: UIViewController = {
       let vc = UIViewController()
        vc.view.backgroundColor = .clear
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    lazy var cat_image_view: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellUI() {
        self.contentView.addSubview(cat_image_view)
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: cat_image_view.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: cat_image_view.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: cat_image_view.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: cat_image_view.bottomAnchor),
        ])
    }
    
    func setImage(catImage: UIImage) {
        UIView.transition(with: cat_image_view, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.cat_image_view.image = catImage
        }, completion: nil)
    }
}
