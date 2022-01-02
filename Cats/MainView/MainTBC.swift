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
        getBarItem(title: "😸", itemVC: MainVC(), imageName: nil),
        getBarItem(title: "Options", itemVC: OptionsVC(), imageName: "slider.horizontal.3"),
        ]
        self.selectedIndex = 0
    }
    
    func getBarItem(title: String, itemVC: UIViewController, imageName: String?) -> UIViewController {
        var itemImage: UIImage?
        var item : UITabBarItem!
        
        if let imageName = imageName {
            itemImage = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate).withTintColor(itemTintColor)
            item = UITabBarItem(title: title, image: itemImage, selectedImage: nil)
        } else {
            item = UITabBarItem(title: title, image: itemImage, selectedImage: nil)
            item.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 30)], for: .normal)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -8)
        }
        itemVC.tabBarItem = item
        return itemVC
    }

}
