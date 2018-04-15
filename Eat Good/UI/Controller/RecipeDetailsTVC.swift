//
//  RecipeDetailsTVC.swift
//  Eat Good
//
//  Created by Arek Otto on 14/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RecipeDetailsTVC: UITableViewController {
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var foodImageView: ScaledHeightImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!

    private var recipe: Recipe!
    private var ingredients: [String]?
    private var image: UIImage?
    
    private var moc = CoreDataManager.persistentContainer.viewContext
    
    private var recipeAsManagedObject: FavoriteRecipe? {
        guard let recipeId = recipe?.recipeId else { return nil }
        return (try? moc.fetch(FavoriteRecipe.fetchRequest(withId: recipeId)))?.first
    }
    
    private var existsInCoreData: Bool {
        return recipeAsManagedObject != nil
    }
    
    private var ingredientsDisplayString: String? {
        guard let ingredients = self.ingredients else { return nil }
        let bulletPointPrefix = "\u{2022}  "
        return (ingredients.map{bulletPointPrefix + $0} as NSArray).componentsJoined(by: "\n")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ingredients == nil {
            fetchIngredients()
        } else {
            ingredientsLabel.text = ingredientsDisplayString
        }
        
        if image == nil, let imageUrl = recipe.imageUrl {
            fetchImage(url: imageUrl)
        } else {
            foodImageView.image = image
        }
        
        titleLabel.text = recipe.title
        publisherLabel.text = recipe.publisher
        ratingLabel.text = String.localizedStringWithFormat("%.2f", recipe.socialRank)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteButton.image = existsInCoreData ? UIImage(named: "FavoriteButtonIcon") : UIImage(named: "FavoriteBorderButtonIcon")
    }
    
    func setup(recipe: Recipe, ingredients: [String]? = nil , image: UIImage? = nil) {
        self.recipe = recipe
        self.image = image
        self.ingredients = ingredients
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 2 else { return }
        if indexPath.row == 3 {
            UIApplication.shared.open(URL(string : recipe.publisherUrl)!)
        } else if indexPath.row == 4 {
            UIApplication.shared.open(URL(string : recipe.sourceUrl)!)
        }
    }
    
    func fetchImage(url: String) {
        ImageRetriever().retrieveImage(urlString: url) {
            guard let image = $0 else { return }
            self.image = image
            DispatchQueue.main.async {
                self.foodImageView.image = image
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
                guard let favRecipe = self.recipeAsManagedObject else { return }
                favRecipe.image = image
                try? self.moc.save()
            }
        }
    }
    
    func fetchIngredients() {
        RecipeSearchRetriever().retrieveIngredients(recipeId: recipe.recipeId) {
            guard let ingredients = $0 else { return }
            self.ingredients = ingredients
            DispatchQueue.main.async {
                self.ingredientsLabel.text = self.ingredientsDisplayString
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .none)
                guard let favRecipe = self.recipeAsManagedObject else { return }
                favRecipe.ingredients = ingredients
                try? self.moc.save()
            }
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        if existsInCoreData {
            moc.delete(recipeAsManagedObject!)
            favoriteButton.image = UIImage(named: "FavoriteBorderButtonIcon")
        } else {
            let favoriteRecipe = NSEntityDescription.insertNewObject(forEntityName: FavoriteRecipe.entityName, into: moc) as! FavoriteRecipe
            favoriteRecipe.update(basedOn: recipe, ingredients: ingredients, image: image)
            favoriteButton.image = UIImage(named: "FavoriteButtonIcon")
        }
        try! moc.save()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        let activityItems = [URL(string: recipe.sourceUrl)!]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender
        present(activityViewController, animated: true, completion: nil)
    }
}

class ImageTableCell: UITableViewCell {
    
    @IBOutlet weak var foodImageView: ScaledHeightImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foodImageView.layer.cornerRadius = 10
    }
}

class ScaledHeightImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        
        guard let image = self.image else {
            return CGSize(width: -1.0, height: -1.0)
        }
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let viewWidth = frame.size.width
        
        let ratio = viewWidth/imageWidth
        let scaledHeight = imageHeight * ratio
        
        return CGSize(width: viewWidth, height: scaledHeight)
    }
    
}
