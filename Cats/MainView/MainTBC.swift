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
        getBarItem(title: "Tags", itemVC: TagExplorerVC(), imageName: "t.circle")
        ]
        self.selectedIndex = 0
    }
    
    func getBarItem(title: String, itemVC: UIViewController, imageName: String) -> UIViewController {
        let itemImage = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate).withTintColor(itemTintColor)
        let item = UITabBarItem(title: title, image: itemImage, selectedImage: nil)
        itemVC.tabBarItem = item
        return itemVC
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
