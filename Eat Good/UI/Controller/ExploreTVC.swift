//
//  ExploreTVC.swift
//  Eat Good
//
//  Created by Arek Otto on 13/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit

class ExploreTVC: UITableViewController {
    
    private var followedFoods = [FollowedFood]()
    
    private var recipeSearchRetriever = RecipeSearchRetriever()
    private var imageRetriever = ImageRetriever()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if followedFoods.map({$0.name}) != FollowedFoodManager.all {
            refreshContent()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        followedFoods.forEach { $0.recipesWithImages.removeAll() }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return followedFoods.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followedFoodTableCell") as! FollowedFoodTableCell
        cell.setup(withRecipesWithImages: followedFoods[indexPath.section].recipesWithImages) {
            let recipeDetailsTVC = self.getRecipeDetailsTVC(recipe: $0, image: $1, shareActionSourceView: tableView.cellForRow(at: indexPath)?.contentView)
            self.navigationController?.pushViewController(recipeDetailsTVC, animated: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let collectionView = (cell as! FollowedFoodTableCell).collectionView!
        collectionView.tag = indexPath.section
        registerForPreviewing(with: self, sourceView: collectionView)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return followedFoods[section].name
    }
    
    // MARK: - Content refresh
    
    func refreshContent() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let dispatchGroup = DispatchGroup()
        followedFoods = FollowedFoodManager.all.map{FollowedFood(name: $0)}
        tableView.reloadData()
        followedFoods.forEach { followedFood in
            dispatchGroup.enter()
            recipeSearchRetriever.retrieveRecipes(page: 1, searchedString: followedFood.name) {
                guard let recipes = $0 else { return }
                followedFood.recipesWithImages = recipes.map{($0, nil)}
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            self.tableView.reloadData()
            self.refreshImages()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    func refreshImages() {
        for followedFoodIndex in 0..<followedFoods.count {
            let followedFood = followedFoods[followedFoodIndex]
            for recipeIndex in 0..<followedFood.recipesWithImages.count {
                guard let imageUrl = followedFood.recipesWithImages[recipeIndex].recipe.imageUrl else { return }
                self.imageRetriever.retrieveImage(urlString: imageUrl) {
                    guard let image = $0 else { return }
                    followedFood.recipesWithImages[recipeIndex].image = image
                    DispatchQueue.main.async {
                        guard let tableCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: followedFoodIndex)) as? FollowedFoodTableCell else { return }
                        tableCell.recipesWithImages[recipeIndex].image = image
                        guard let collectionCell = tableCell.collectionView.cellForItem(at: IndexPath(row: recipeIndex, section: 0)) as? RecipeCollectionCell else { return }
                        collectionCell.setFoodImage(image)
                    }
                }
            }
        }
    }
    
    class FollowedFood {
        var name: String
        var recipesWithImages: [(recipe: Recipe, image: UIImage?)]
        
        init(name: String, recipesWithImages: [(recipe: Recipe, image: UIImage?)] = []) {
            self.name = name
            self.recipesWithImages = recipesWithImages
        }
    }
}

extension ExploreTVC: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let collectionView = previewingContext.sourceView as! UICollectionView
        guard let collectionIndexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let collectionCell = collectionView.cellForItem(at: collectionIndexPath) else { return nil}
        
        let recipeWithImage = self.followedFoods[collectionView.tag].recipesWithImages[collectionIndexPath.row]
        let recipeDetailsTVC = getRecipeDetailsTVC(recipe: recipeWithImage.recipe, image: recipeWithImage.image, shareActionSourceView: collectionCell)
        previewingContext.sourceRect = collectionCell.frame
        
        return recipeDetailsTVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    
}

