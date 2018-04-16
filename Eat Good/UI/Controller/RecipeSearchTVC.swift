//
//  RecipeSearchTVC.swift
//  Eat Good
//
//  Created by Arek Otto on 14/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit

class RecipeSearchTVC: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var recipeSearchRetriever = RecipeSearchRetriever()
    private var imageRetriever = ImageRetriever()

    private var searchedRecipes = [Recipe]()
    private var imageCache = Cache<UIImage>(maxSize: 30)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        setupSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        searchController.isActive = false
        searchedRecipes.removeAll()
        imageCache.removeAll()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedRecipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "smallFoodTableCell") as! SmallFoodTableCell
        let recipe = searchedRecipes[indexPath.row]
        cell.setup(title: recipe.title, publisher: recipe.publisher, image: nil)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let imgIndex = indexPath.row
        let recipe = searchedRecipes[imgIndex]
        guard let imageUrl = recipe.imageUrl else { return }
        
        cell.tag = imgIndex
        let largeFoodTableCell = cell as! SmallFoodTableCell
        if let image = imageCache.object(forKey: imgIndex) {
            largeFoodTableCell.foodImageView.image = image
        } else {
            imageRetriever.retrieveImage(urlString: imageUrl) { image in
                guard let img = image else { return }
                self.imageCache.insert(object: img, forKey: imgIndex)
                DispatchQueue.main.async {
                    guard largeFoodTableCell.tag == imgIndex else { return }
                    largeFoodTableCell.foodImageView.image = img
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageIndex = indexPath.row
        let cell = tableView.cellForRow(at: indexPath)
        let recipeDetailsTVC = getRecipeDetailsTVC(recipe: searchedRecipes[imageIndex], image: imageCache.object(forKey: imageIndex), shareActionSourceView: cell)
        navigationController?.pushViewController(recipeDetailsTVC, animated: true)
    }
    
    // MARK: - SearchCotroller setup

    private func setupSearchController() {
        if #available(iOS 11, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
    }
}

extension RecipeSearchTVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchedString = searchBar.text, searchedString != "" else {
            searchedRecipes.removeAll()
            tableView.reloadData()
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        recipeSearchRetriever.retrieveRecipes(page: 1, searchedString: searchedString) { aa in
            DispatchQueue.main.async {
                self.searchedRecipes = aa ?? []
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchedRecipes.removeAll()
        tableView.reloadData()
    }
}
