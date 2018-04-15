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

    var searchedRecipes = [Recipe]()
    
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
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func setupSearchController() {
        if #available(iOS 11, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchResultsUpdater = self
    }
}

extension RecipeSearchTVC: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        recipeSearchRetriever.retrieveRecipes(page: 1) {
            self.searchedRecipes = $0 ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    
}
