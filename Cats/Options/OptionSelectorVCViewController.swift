//
//  tagSelectorVCViewController.swift
//  Cats
//
//  Created by Daniel Wood on 12/30/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit

fileprivate let TAG_CELL_ID = "tag_cell_id"
class OptionSelectorVCViewController: UIViewController {

    var delegate: OptionValueChangedDelegate!
    
    lazy var optionsTable: UITableView = {
        let table = UITableView(frame: CGRect.zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.button_height + 10, right: 0)
        table.backgroundColor = .secondarySystemGroupedBackground
        return table
    }()
    
    lazy var searchView: UISearchBar = {
        let sv = UISearchBar()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsCancelButton = true
        return sv
    }()
    
    lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = Constants.button_corner_radius
        btn.backgroundColor = .cyan
        btn.setTitle("Dismiss", for: .normal)
        btn.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return btn
    }()
    
    var allOptions: [String] = [] {
        didSet {
            filteredOptions = allOptions
        }
    }
    
    var filteredOptions: [String] = [] {
        didSet {
            optionsTable.reloadData()
        }
    }
    
    var optionType: OptionType!
    
    //MARK: - Lifecycle
    
    convenience init(optionType: OptionType, options: [String], delegate: OptionValueChangedDelegate) {
        self.init()
        self.optionType = optionType
        self.allOptions = options
        self.filteredOptions = options
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - SetupUI
    func setupUI() {
        self.view.backgroundColor = .secondarySystemGroupedBackground
        optionsTable.delegate = self
        optionsTable.dataSource = self
        optionsTable.register(UITableViewCell.self, forCellReuseIdentifier: TAG_CELL_ID)
        searchView.delegate = self
        self.view.addSubviews([searchView, optionsTable, cancelButton])
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: self.view.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            optionsTable.topAnchor.constraint(equalTo: self.searchView.bottomAnchor),
            optionsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            optionsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            optionsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.button_height),
            cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10)
        ])
    }
    
    //MARK: - Helpers
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    func filterTags() {
        if let searchText = searchView.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
            filteredOptions = allOptions.filter({ (option) -> Bool in
                option.contains(searchText)
            })
        } else {
            filteredOptions = allOptions
        }
    }
    
}

//MARK: - UITableView
extension OptionSelectorVCViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TAG_CELL_ID, for: indexPath)
        cell.textLabel?.text = filteredOptions[indexPath.row]
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
        cell.tag = indexPath.row
        return cell
    }
    
    @objc func cellTapped(sender: UITapGestureRecognizer) {
        if let index = sender.view?.tag, let delegate = self.delegate {
            delegate.optionValueChanged(optionValue: filteredOptions[index], optionType: self.optionType)
            dismissSelf()
        }
    }
}

//MARK: - UISearchBar
extension OptionSelectorVCViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTags()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchView.text = ""
        searchView.resignFirstResponder()
        filteredOptions = allOptions
    }
}

protocol OptionValueChangedDelegate {
    func optionValueChanged(optionValue: String, optionType: OptionType)
}
