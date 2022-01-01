//
//  UIViewController+Extension.swift
//  Cats
//
//  Created by Daniel Wood on 12/29/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import Foundation
import UIKit

fileprivate let ALERT_TAG = -100
extension UIViewController {
    
    func showLoadingViewWithMessage() {
        let alert = UIAlertController(title: nil, message: "Making things purrrfect...", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame: CGRect(x: -5, y: 5, width: 50, height: 50))
        indicator.startAnimating()
        alert.view.addSubview(indicator)
        alert.view.tag = ALERT_TAG
        present(alert, animated: true, completion: nil)
    }
    
    func showLoadingView() {
        
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        makeEveryBackgroundClear(view: alert.view)
        
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
 
        indicator.startAnimating()
        alert.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.heightAnchor.constraint(equalToConstant: 50),
            indicator.widthAnchor.constraint(equalToConstant: 50),
            indicator.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
        ])
        alert.view.tag = ALERT_TAG
        present(alert, animated: true, completion: nil)
        
//        let loadingView = UIViewController()
//        loadingView.view.translatesAutoresizingMaskIntoConstraints = false
//        loadingView.modalPresentationStyle = .overCurrentContext
//        let indicator = UIActivityIndicatorView()
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        loadingView.view.addSubview(indicator)
//        NSLayoutConstraint.activate([
//            indicator.centerYAnchor.constraint(equalTo: loadingView.view.centerYAnchor),
//            indicator.centerXAnchor.constraint(equalTo: loadingView.view.centerXAnchor),
//            indicator.heightAnchor.constraint(equalToConstant: 50),
//            indicator.widthAnchor.constraint(equalToConstant: 50)
//        ])
//        indicator.startAnimating()
//        present(loadingView, animated: true, completion: {
//        print("ausdhiauhsdiauhsd")
//        })
    }
    
    func makeEveryBackgroundClear(view: UIView) {
        for subview in view.subviews {
            makeEveryBackgroundClear(view: subview)
        }
    }
    	
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showToast(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}
