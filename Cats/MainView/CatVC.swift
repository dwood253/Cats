//
//  catVC.swift
//  Cats
//
//  Created by Daniel Wood on 12/28/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit

class CatVC: UINavigationController {
    lazy var catImageView: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.view.addSubview(catImageView)
        catImageView.fillSuperView()
    }
    
    func setCatImage(catImage: UIImage, caption: String?) {
        UIView.transition(from: self.catImageView, to: self.catImageView, duration: 0.2, options: .transitionCrossDissolve, completion: nil)
        self.catImageView.image = catImage
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
