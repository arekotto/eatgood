//
//  RecipeDetailsTVC.swift
//  Eat Good
//
//  Created by Arek Otto on 14/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailsTVC: UITableViewController {
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var foodImageView: ScaledHeightImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!

    private var recipe: Recipe!
    private var image: UIImage?
    
    private var existsInCoreData: Bool {
        guard let recipeId = recipe?.recipeId else { return false }
        let moc = CoreDataManager.persistentContainer.viewContext
        return (try? moc.fetch(FavoriteRecipe.fetchRequest(withId: recipeId)))?.first != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchIngredeints()
        
        if image == nil, let imageUrl = recipe.imageUrl {
            fetchImage(url: imageUrl)
        } else {
            foodImageView.image = image
        }
        
        if existsInCoreData {
            
        }
        
        titleLabel.text = recipe.title
        publisherLabel.text = recipe.publisher
        ratingLabel.text = String.localizedStringWithFormat("%.2f", recipe.socialRank)
    }
    
    func setup(with recipe: Recipe, and image: UIImage? = nil) {
        self.recipe = recipe
        self.image = image
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
            self.image = $0
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
        }
    }
    
    func fetchIngredeints() {
        RecipeSearchRetriever().retrieveIngredients(recipeId: recipe.recipeId) {
            guard let ingredients = $0 else { return }
            DispatchQueue.main.async {
                let bulletPoint = "\u{2022}  "
                self.ingredientsLabel.text = (ingredients.map{bulletPoint + $0} as NSArray).componentsJoined(by: "\n")
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .none)
            }
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
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
