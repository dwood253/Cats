//
//  tagSelectorVCViewController.swift
//  Cats
//
//  Created by Daniel Wood on 12/30/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit

fileprivate let TAG_CELL_ID = "tag_cell_id"
class TagSelectorVCViewController: UIViewController {

    var delegate: TagSelectedDelegate?
    
    lazy var tagsTable: UITableView = {
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
        btn.setTitle("Cancel", for: .normal)
        btn.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return btn
    }()
    
    var tagOptions: [String] = [] {
        didSet {
            filteredOptions = tagOptions
        }
    }
    
    var filteredOptions: [String] = [] {
        didSet {
            tagsTable.reloadData()
        }
    }
    
    //MARK: - Lifecycle
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
        tagsTable.delegate = self
        tagsTable.dataSource = self
        tagsTable.register(UITableViewCell.self, forCellReuseIdentifier: TAG_CELL_ID)
        searchView.delegate = self
        self.view.addSubviews([searchView, tagsTable, cancelButton])
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: self.view.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tagsTable.topAnchor.constraint(equalTo: self.searchView.bottomAnchor),
            tagsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tagsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tagsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
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
            filteredOptions = tagOptions.filter({ (option) -> Bool in
                option.contains(searchText)
            })
        } else {
            filteredOptions = tagOptions
        }
    }
    
}

//MARK: - UITableView
extension TagSelectorVCViewController: UITableViewDelegate, UITableViewDataSource {
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
            delegate.tagSelected(tag: filteredOptions[index])
            dismissSelf()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.tagSelected(tag: filteredOptions[indexPath.row])
        }
    }
}

//MARK: - UISearchBar
extension TagSelectorVCViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTags()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchView.text = ""
        searchView.resignFirstResponder()
        filteredOptions = tagOptions
    }
}

protocol TagSelectedDelegate {
    func tagSelected(tag: String)
}
