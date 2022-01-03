//
//  UIImageView+Extension.swift
//  Cats
//
//  Created by Daniel Wood on 1/2/22.
//  Copyright © 2022 Daniel Wood. All rights reserved.
//

import UIKit
extension UIImageView {
    func asGif(gifData: CFData) {
        guard let source =  CGImageSourceCreateWithData(gifData, nil) else { return }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        self.animationImages = images
    }
}
