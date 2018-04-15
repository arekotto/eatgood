//
//  FavoritesTVC.swift
//  Eat Good
//
//  Created by Arek Otto on 15/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit

class FavoritesTVC: UITableViewController {
    
    private var favoriteRecipes = [FavoriteRecipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let moc = CoreDataManager.persistentContainer.viewContext
        favoriteRecipes = (try? moc.fetch(FavoriteRecipe.fetchRequest())) ?? []
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "smallFoodTableCell") as! SmallFoodTableCell
        let favoriteRecipe = favoriteRecipes[indexPath.row]
        cell.setup(title: favoriteRecipe.title, publisher: favoriteRecipe.publisher, image: favoriteRecipe.image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteRecipe = favoriteRecipes[indexPath.row]
        pushRecipeDetailsTVC(recipe: favoriteRecipe.extractRecipe(), image: favoriteRecipe.image, ingredients: favoriteRecipe.ingredients)
    }

}
