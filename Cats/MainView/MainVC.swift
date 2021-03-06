//
//  ViewController.swift
//  Cats
//
//  Created by Daniel Wood on 12/22/21.
//  Copyright © 2021 Daniel Wood. All rights reserved.
//

import UIKit

fileprivate let RELOAD_BUTTON_DIMENSION: CGFloat = 20
fileprivate let THROTTLE_MESSAGE_DISPLAY_TIME: TimeInterval = 3

class MainVC: UIViewController {
    
    lazy var backgroundImageView:UIImageView = {
        let imgv = UIImageView()
        imgv.translatesAutoresizingMaskIntoConstraints = false
        imgv.contentMode = .scaleAspectFill
        return imgv
    }()
    
    lazy var displayImageView:UIImageView = {
        let imgv = UIImageView()
        imgv.translatesAutoresizingMaskIntoConstraints = false
        imgv.contentMode = .scaleAspectFit
        return imgv
    }()
    
    lazy var displayGif: UIImageView = {
        let imgv = UIImageView()
      imgv.translatesAutoresizingMaskIntoConstraints = false
      imgv.contentMode = .scaleAspectFit
      return imgv
    }()
    
    lazy var reloadButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "goforward"), for: .normal)
        btn.addTarget(self, action: #selector(initiateCatSequence), for: .touchUpInside)
        return btn
    }()
    
    var isReloading: Bool = false
    
    let imageDispatchGroup = DispatchGroup()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initiateCatSequence()
    }
    
    //MARK: - SetupUI
    func setupUI() {
        self.view.addSubviews([backgroundImageView, displayImageView, displayGif, reloadButton])
        backgroundImageView.fillSuperView()
        NSLayoutConstraint.activate([
            displayImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            displayImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            displayImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            displayImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
            displayGif.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            displayGif.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            displayGif.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            displayGif.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
            reloadButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            reloadButton.heightAnchor.constraint(equalToConstant: RELOAD_BUTTON_DIMENSION),
            reloadButton.widthAnchor.constraint(equalToConstant: RELOAD_BUTTON_DIMENSION),
            reloadButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
    
    @objc func initiateCatSequence() {
        let randomIndex = Int.random(in: 0..<Constants.FetchingKittingMessages.count)
        let message = Constants.FetchingKittingMessages[randomIndex]
        self.showLoadingView(message: message)
        loadNewImage()
    }
    
    func loadNewImage() {
        let url = Session.data.getUrl()
        NetworkingManager.shared.getCat(url: url) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.dismissLoadingViewNoAsync()
                UIView.transition(with: self.backgroundImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.backgroundImageView.image = self.getImageWithBlur(image)
                }, completion: nil)
                UIView.transition(with: self.displayImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.displayImageView.image = UIImage.animatedImage(with: [image], duration: 0.3)
                }, completion: nil)
                if url.contains("gif") {
                    self.displayImageView.isHidden = true
                    self.view.addSubview(self.displayGif)
                    self.displayGif.asGif(gifData: NetworkingManager.shared.previouslyFetchedData! as CFData)
                    self.displayGif.startAnimating()
                    self.displayGif.isHidden = false
                } else {
                    self.displayGif.stopAnimating()
                    self.displayGif.isHidden = true
                    self.displayImageView.isHidden = false
                }
                self.view.bringSubviewToFront(self.reloadButton)
            case .failure(let error):
                self.dismissLoadingViewWithCompletion {
                    self.showToast(error.error, forDuration: THROTTLE_MESSAGE_DISPLAY_TIME)
                }
            }
        }
       
    }
    var context = CIContext(options: nil)
    func getImageWithBlur(_ image: UIImage) -> UIImage? {
        guard let filter = CIFilter(name: "CIGaussianBlur"), let cropFilter = CIFilter(name: "CICrop"), let ogImage = CIImage(image: image) else { return nil }
       
        filter.setValue(ogImage, forKey: kCIInputImageKey)
        filter.setValue(5, forKey: kCIInputRadiusKey)
        
        cropFilter.setValue(filter.outputImage, forKey: kCIInputImageKey)
        cropFilter.setValue(CIVector(cgRect: ogImage.extent), forKey: "inputRectangle")
        
        guard let cropOutput = cropFilter.outputImage, let contextOutput = context.createCGImage(cropOutput, from: cropOutput.extent) else { return nil }
        return UIImage(cgImage: contextOutput)
    }
    
}

