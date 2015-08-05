//
//  BaseChooserTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 04.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class UnitChooserTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private struct Constants {
        static let cellIdentifier = "unitCell"
    }

    // These ones arent optional because it leads to a compiler error
    // Using optional made it impossible to use indexPath.row to access
    // an array member.
    // TODO: Change it later
    var weightItems = [WeightUnit]()
    var distanceItems = [DistanceUnit]()

    var key: String!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weightItems.count > 0 {
            return weightItems.count
        } else if distanceItems.count > 0 {
            return distanceItems.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath) as! UITableViewCell

        if weightItems.count > 0 {
            cell.textLabel?.text = "\(weightItems[indexPath.row])"
        } else if distanceItems.count > 0 {
            cell.textLabel?.text = "\(distanceItems[indexPath.row])"
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        prepareBackSegue(indexPath)
        navigationController?.popToRootViewControllerAnimated(true)
    }

    private func prepareBackSegue(indexPath: NSIndexPath) {
        if key == SettingsKeys.weight {
            let item = weightItems[indexPath.row].rawValue
            NSUserDefaults.standardUserDefaults().setInteger(item, forKey: key)
        } else if key == SettingsKeys.distance {
            let item = distanceItems[indexPath.row].rawValue
            NSUserDefaults.standardUserDefaults().setInteger(item, forKey: key)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
