//
//  ViewController.swift
//  Eat Good
//
//  Created by Arek Otto on 10/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit

class TopRatedTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") as! LargeFoodTableCell
        cell.wrappingView.layer.cornerRadius = 26
        return cell
    }
}

class LargeFoodTableCell: UITableViewCell {
    
    @IBOutlet weak var wrappingView: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pubisherLabel: UILabel!
}

