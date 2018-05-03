//
//  FavoritesTVC.swift
//  Eat Good
//
//  Created by Arek Otto on 15/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private let moc = CoreDataManager.persistentContainer.viewContext
    private var fetchedResultsController: NSFetchedResultsController<FavoriteRecipe>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        updateEditingButton()
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "smallFoodTableCell") as! SmallFoodTableCell
        let favoriteRecipe = fetchedResultsController.object(at: indexPath)
        cell.setup(with: favoriteRecipe)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteRecipe = fetchedResultsController.object(at: indexPath)
        let cell = tableView.cellForRow(at: indexPath)
        let recipeDetailsTVC = getRecipeDetailsTVC(recipe: favoriteRecipe.extractRecipe(), image: favoriteRecipe.image, ingredients: favoriteRecipe.ingredients, shareActionSourceView: cell)
        navigationController?.pushViewController(recipeDetailsTVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let hasFavoriteRecipes = fetchedResultsController.fetchedObjects?.count ?? 0 > 0
        return hasFavoriteRecipes ? nil : NSLocalizedString("Favorite recipes will appear here.", comment: "")
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        moc.delete(fetchedResultsController.object(at: indexPath))
        try! moc.save()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [insertIndexPath], with: .automatic)
        case .update:
            guard let updateIndexPath = indexPath else { return }
            let cell = tableView.cellForRow(at: updateIndexPath) as! SmallFoodTableCell
            guard let favRecipe = anObject as? FavoriteRecipe else { return }
            cell.setup(with: favRecipe)
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            tableView.deleteRows(at: [deleteIndexPath], with: .automatic)
        case .move:
            guard let deleteIndexPath = indexPath else { return }
            tableView.deleteRows(at: [deleteIndexPath], with: .automatic)
            guard let insertIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [insertIndexPath], with: .automatic)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    @objc func editingButtonTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        updateEditingButton()
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(FavoriteRecipe.title), ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
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
