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

    private var previewShareAction: ((_ recipe: Recipe) -> Void)?
    
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
        navigationController?.view.backgroundColor = .white
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        if segueId == "showImage" {
            guard let img = image else { return }
            (segue.destination as! ImageVC).setup(with: img)
        }
    }
    
    func setup(recipe: Recipe, ingredients: [String]? = nil , image: UIImage? = nil, previewShareAction: ((_ recipe: Recipe) -> Void)? = nil) {
        self.recipe = recipe
        self.image = image
        self.ingredients = ingredients
        self.previewShareAction = previewShareAction
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            performSegue(withIdentifier: "showImage", sender: self)
        } else if indexPath.section == 2 {
            if indexPath.row == 3 {
                UIApplication.shared.open(URL(string : recipe.publisherUrl)!)
            } else if indexPath.row == 4 {
                UIApplication.shared.open(URL(string : recipe.sourceUrl)!)
            }
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
            removeFromFavorites()
        } else {
            addToFavorites()
        }
        try! moc.save()
    }
    
    private func addToFavorites() {
        let favoriteRecipe = NSEntityDescription.insertNewObject(forEntityName: FavoriteRecipe.entityName, into: moc) as! FavoriteRecipe
        favoriteRecipe.update(basedOn: recipe, ingredients: ingredients, image: image)
        favoriteButton.image = UIImage(named: "FavoriteButtonIcon")
    }
    
    private func removeFromFavorites() {
        moc.delete(recipeAsManagedObject!)
        favoriteButton.image = UIImage(named: "FavoriteBorderButtonIcon")
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        shareRecipe(recipe, sourceView: sender)
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        
        let favoriteAction: UIPreviewAction
        if existsInCoreData {
            let title = NSLocalizedString("Unfavorite", comment: "")
            favoriteAction = UIPreviewAction(title: title, style: .destructive) { _, _ in
                self.removeFromFavorites()
            }
        } else {
            let title = NSLocalizedString("Favorite", comment: "")
            favoriteAction = UIPreviewAction(title: title, style: .default) { _, _ in
                self.addToFavorites()
            }
        }
        let shareAction = UIPreviewAction(title: NSLocalizedString("Share", comment: ""), style: .default) {_,_  in
            self.previewShareAction?(self.recipe)
        }
        return [favoriteAction, shareAction]
    }
}

