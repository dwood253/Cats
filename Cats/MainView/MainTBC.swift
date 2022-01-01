//
//  mainTBC.swift
//  Cats
//
//  Created by Daniel Wood on 12/28/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit

fileprivate let itemTintColor: UIColor = .white
fileprivate let selectedItemTintColor: UIColor = .cyan

class MainTBC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    func setupTabs() {
        self.viewControllers = [
        getBarItem(title: "Cats", itemVC: MainVC(), imageName: "star"),
        getBarItem(title: "Options", itemVC: OptionsVC(), imageName: "slider.horizontal.3"),
        ]
        self.selectedIndex = 0
    }
    
    func getBarItem(title: String, itemVC: UIViewController, imageName: String) -> UIViewController {
        let itemImage = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate).withTintColor(itemTintColor)
        let item = UITabBarItem(title: title, image: itemImage, selectedImage: nil)
        itemVC.tabBarItem = item
        return itemVC
    }

}
