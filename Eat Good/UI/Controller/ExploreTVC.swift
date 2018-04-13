//
//  ExploreTVC.swift
//  Eat Good
//
//  Created by Arek Otto on 13/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit

class ExploreTVC: UITableViewController {
    
    private var followedFoodNames = FollowedFoodManager.all

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if followedFoodNames != FollowedFoodManager.all {
            followedFoodNames = FollowedFoodManager.all
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return followedFoodNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followedFoodTableCell") as! FollowedFoodTableCell
        cell.setup(with: followedFoodNames[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return followedFoodNames[section]
    }
}

class FollowedFoodTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var imageRetriever = ImageRetriever()
    private var recipeSearchRetriever = RecipeSearchRetriever()

    private var recipes = [Recipe]()
    
    private var imageCache = Cache<UIImage>(maxSize: 20)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with followedFoodName: String) {
        imageCache.removeAll()
        recipeSearchRetriever.retrieveRecipes(page: 1, searchedString: followedFoodName) {
            guard let recipes = $0 else { return }
            self.recipes = recipes
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCollectionCell", for: indexPath) as! RecipeCollectionCell
        cell.setup(with: recipes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let imgIndex = indexPath.row
        let recipe = recipes[imgIndex]
        guard let imageUrl = recipe.imageUrl else { return }
        
        let recipeCollectionCell = cell as! RecipeCollectionCell
        if let image = imageCache.object(forKey: imgIndex) {
            recipeCollectionCell.setFoodImage(image)
        } else {
            imageRetriever.retrieveImage(urlString: imageUrl) { image in
                guard let img = image else { return }
                self.imageCache.insert(object: img, forKey: imgIndex)
                DispatchQueue.main.async {
                    guard recipeCollectionCell.tag == imgIndex else { return }
                    recipeCollectionCell.setFoodImage(img)
                }
            }
        }
    }
}

class RecipeCollectionCell: UICollectionViewCell {
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var wrappingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wrappingView.layer.cornerRadius = 5
    }
    
    func setFoodImage(_ image: UIImage) {
        foodImageView?.image = image
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func setup(with recipe: Recipe) {
        titleLabel.text = recipe.title
        foodImageView?.image = nil
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
}
