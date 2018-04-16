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
    private let moc = CoreDataManager.persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        updateEditingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let cell = tableView.cellForRow(at: indexPath)
        let recipeDetailsTVC = getRecipeDetailsTVC(recipe: favoriteRecipe.extractRecipe(), image: favoriteRecipe.image, ingredients: favoriteRecipe.ingredients, shareActionSourceView: cell)
        navigationController?.pushViewController(recipeDetailsTVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return favoriteRecipes.isEmpty ? NSLocalizedString("Favorite recipes will appear here.", comment: "") : nil
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        moc.delete(favoriteRecipes.remove(at: indexPath.row))
        try! moc.save()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    @objc func editingButtonTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        updateEditingButton()
    }
    
    func updateEditingButton() {
        if tableView.isEditing {
            let title = NSLocalizedString("Done", comment: "")
            navigationItem.setLeftBarButton(UIBarButtonItem(title: title, style: .done, target: self, action: #selector(editingButtonTapped)), animated: true)
        } else {
            let title = NSLocalizedString("Edit", comment: "")
            navigationItem.setLeftBarButton(UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(editingButtonTapped)), animated: true)
        }
    }
}
