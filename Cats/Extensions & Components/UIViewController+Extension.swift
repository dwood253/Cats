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
    
    func showLoadingView(message: String = "Making things purrrfect...") {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame: CGRect(x: -5, y: 5, width: 50, height: 50))
        indicator.startAnimating()
        alert.view.addSubview(indicator)
        alert.view.tag = ALERT_TAG
        present(alert, animated: true, completion: nil)
    }
    	
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func dismissLoadingViewWithCompletion(completion: @escaping() -> Void){
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: {
                completion()
            })
        }
    }
    
    func dismissLoadingViewNoAsync() {
         self.dismiss(animated: true, completion: nil)
     }
    
    func showToast(_ message: String, forDuration: TimeInterval = 1) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        self.perform(#selector(dismissToast), with: nil, afterDelay: forDuration)
    }
    
    @objc func dismissToast() {
        self.dismiss(animated: true, completion: nil)
    }
}
