//
//  FollowedFoodsEditTVC.swift
//  Eat Good
//
//  Created by Arek Otto on 13/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation
import UIKit

class FollowedFoodEditTVC: UITableViewController {
    
    private let foodManager = FollowedFoodManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = true
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodManager.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleTableCell") as! TitleTableCell
        cell.titleLabel.text = foodManager.all[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        var followedFoodNames = foodManager.all
        followedFoodNames.remove(at: indexPath.row)
        foodManager.all = followedFoodNames
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var followedFoodNames = foodManager.all
        let followedFoodName = followedFoodNames.remove(at: sourceIndexPath.row)
        followedFoodNames.insert(followedFoodName, at: destinationIndexPath.row)
        foodManager.all = followedFoodNames
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard foodManager.all.count < 10 else {
            let title = NSLocalizedString("Already Following 10", comment: "")
            let message = NSLocalizedString("You already have 10 types of food followed. Please remove some of them before adding any more.", comment: "")
            presentAlertWithOkAction(title: title, message: message)
            return
        }
        let title = NSLocalizedString("Follow Food", comment: "")
        let message = NSLocalizedString("Type in the food you want to see in the explore tab.", comment: "")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField{
            $0.placeholder = title
        }
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Follow", comment: ""), style: .default) { _ in
            guard let followedFood = alertController.textFields!.first!.text else { return }
            var followedFoodNames = self.foodManager.all
            followedFoodNames.append(followedFood)
            self.foodManager.all = followedFoodNames
            self.tableView.insertRows(at: [IndexPath(row: followedFoodNames.count - 1, section: 0)], with: .automatic)
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel))
        present(alertController, animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
