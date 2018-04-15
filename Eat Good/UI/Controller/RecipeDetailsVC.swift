////
////  RecipeDetailsVC.swift
////  Eat Good
////
////  Created by Arek Otto on 14/04/2018.
////  Copyright © 2018 Arek Otto. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class RecipeDetailsVC: UIViewController {
//    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var foodImageView: UIImageView!
//    @IBOutlet weak var recipeLabel: UILabel!
//    
//    private var recipe: Recipe!
//    private var image: UIImage?
//    
//    private var hidesBarsOnSwipeParentSetting: Bool!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if image == nil, let imageUrl = recipe.imageUrl {
//            ImageRetriever().retrieveImage(urlString: imageUrl) {
//                self.image = $0
//                DispatchQueue.main.async {
////                    self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
//                    self.foodImageView.image = self.image
//                }
//            }
//        } else {
//            foodImageView.image = image            
//        }
//        titleLabel.text = recipe.title
//        recipeLabel.text = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nsadfadsfasdfdsafasfsd\n\n\n\n\n\n\nfasdfasdfas"
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        hidesBarsOnSwipeParentSetting = navigationController?.hidesBarsOnSwipe
//        navigationController?.hidesBarsOnSwipe = true
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.hidesBarsOnSwipe = true
//
//    }
//    
//    func setup(with recipe: Recipe, and image: UIImage? = nil) {
//        self.recipe = recipe
//        self.image = image
//
//    }
//}
