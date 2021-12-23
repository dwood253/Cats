//
//  ViewController.swift
//  Cats
//
//  Created by Daniel Wood on 12/22/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit

fileprivate let CELL_ID = "cat_cell_id"

class mainVC: UIViewController {
    lazy var catTable: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .secondarySystemBackground
        return table
    }()
    let tableRefresh = UIRefreshControl()
    var urlToUse: String? = nil
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var catCollection: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    fileprivate func setupUI() {
        self.view.backgroundColor = .secondarySystemBackground
        setupTable()
    }
    
    //MARK: - Setup UI
    
    fileprivate func setupData() {
        getRandomCat()
    }
    
    fileprivate func setupTable() {
        self.view.addSubview(catTable)
        catTable.fillSuperView(insets: UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0, bottom: self.view.safeAreaInsets.bottom, right: 0))
        catTable.delegate = self
        catTable.dataSource = self
        catTable.register(catTableCell.self, forCellReuseIdentifier: CELL_ID)
        //Add refresh option for pull down
        tableRefresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableRefresh.attributedTitle = NSAttributedString(string: "Fetch a cat. MEOW!")
        catTable.addSubview(tableRefresh)
    }
    
    //MARK: - Helpers
    
    @objc func refreshTable() {
        if let url = self.urlToUse {
            getSpecificCat(url)
        } else {
            getRandomCat()
        }
    }
    
    func getRandomCat() {
        NetworkingManager.shared.fetchRandomCat { result in
            switch result {
            case .success(let catImage):
                self.catCollection = [catImage]
                self.catTable.reloadData()
            case .failure(_):
                break
                //TODO: Handle this failure
            }
            self.tableRefresh.endRefreshing()
        }
    }
    
    func getSpecificCat(_ url: String) {
        NetworkingManager.shared.getSpecificCat(url: url) { result in
            switch result {
            case .success(let catImage):
                self.catCollection = [catImage]
                self.catTable.reloadData()
            case .failure(_):
                break
                //TODO: Handle this failure
            }
            self.tableRefresh.endRefreshing()
        }
    }
}

//MARK: - UITableView Stuff
extension mainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! catTableCell
        cell.setupCell(image: catCollection[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - UITableCell Stuff
class catTableCell: UITableViewCell {
    
    lazy var cellImage: UIImageView = {
       let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellUI() {
        self.addSubview(cellImage)
        cellImage.fillSuperView()
    }
    
    func setupCell(image: UIImage) {
        self.cellImage.image = image
    }
}
