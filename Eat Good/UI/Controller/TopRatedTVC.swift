//
//  ViewController.swift
//  Eat Good
//
//  Created by Arek Otto on 10/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class TopRatedTVC: UITableViewController {
    
    private var recipeSearchRetriever = RecipeSearchRetriever()
    private var imageRetriever = ImageRetriever()

    private var recipes = [Recipe]()
    private var imageCache = Cache<UIImage>(maxSize: 20)
    
    private var apiPageIndex = 1
    private let maxApiPageIndex = 5

    private let detailsSegueId = "showDetails"
    
    private let refreshInterval = 10
    private var lastRefresh: Date?
    private var shouldRefresh: Bool {
        guard lastRefresh != nil else {
            return true
        }
        return Calendar.current.date(byAdding: .minute, value: refreshInterval, to: lastRefresh!)! < Date()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = .white
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard shouldRefresh else { return }
        refreshContentForCurrentApiPageIndex()
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        imageCache.removeAll()
        recipes.removeAll()
        apiPageIndex = 1
        lastRefresh = nil
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") as! LargeFoodTableCell
        cell.setup(with: recipes[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let imgIndex = indexPath.row
        let recipe = recipes[imgIndex]
        guard let imageUrl = recipe.imageUrl else { return }
        
        cell.tag = imgIndex
        let largeFoodTableCell = cell as! LargeFoodTableCell
        if let image = imageCache.object(forKey: imgIndex) {
            largeFoodTableCell.setFoodImage(image)
        } else {
            imageRetriever.retrieveImage(urlString: imageUrl) { image in
                guard let img = image else { return }
                self.imageCache.insert(object: img, forKey: imgIndex)
                DispatchQueue.main.async {
                    guard largeFoodTableCell.tag == imgIndex else { return }
                    largeFoodTableCell.setFoodImage(img)
                }
            }
            if shouldLoadNextRecipes(currentlyDisplayedRow: imgIndex) {
                apiPageIndex += 1
                refreshContentForCurrentApiPageIndex()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let recipeDetailsTVC = getRecipeDetailsTVC(recipe: recipes[indexPath.row], image: imageCache.object(forKey: indexPath.row), shareActionSourceView: cell)
        navigationController?.pushViewController(recipeDetailsTVC, animated: true)
    }
    
    func shouldLoadNextRecipes(currentlyDisplayedRow: Int) -> Bool {
        return recipes.count - 4 < currentlyDisplayedRow
    }
    
    func refreshContentForCurrentApiPageIndex() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        recipeSearchRetriever.retrieveRecipes(page: apiPageIndex) {
            guard let recipes = $0 else { return }
            if self.apiPageIndex == 1 {
                self.recipes = recipes
            } else {
                self.recipes.append(contentsOf: recipes)
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.tableView.reloadData()
            }
        }
        lastRefresh = Date()
    }
}

extension TopRatedTVC: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        let recipeDetailsTVC = getRecipeDetailsTVC(recipe: recipes[indexPath.row], image: imageCache.object(forKey: indexPath.row), shareActionSourceView: cell)
        previewingContext.sourceRect = cell.frame
        
        return recipeDetailsTVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
