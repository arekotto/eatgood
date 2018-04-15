//
//  FavoritesTVC.swift
//  Eat Good
//
//  Created by Arek Otto on 15/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    private var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        navigationController?.hidesBarsOnTap = true

//        let tapper = UITapGestureRecognizer(target: self, action: #selector(toggleNavBar))
//        tapper.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapper)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.hidesBarsOnTap = false
    }
    
    func setup(with image: UIImage) {
        self.image = image
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
//    @objc func toggleNavBar() {
//        navigationController?.setNavigationBarHidden(!navigationController!.isNavigationBarHidden, animated: true)
//    }
    
}
