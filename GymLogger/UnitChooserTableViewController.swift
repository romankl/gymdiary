//
//  BaseChooserTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 04.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class UnitChooserTableViewController: UITableViewController {

    private var prevItem = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        let selectedKey = SettingsKeys(rawValue: key)!

        switch selectedKey {
        case .distance:
            title = NSLocalizedString("Distance Unit", comment: "Distance unit settings tableView title")

        case .weight:
            title = NSLocalizedString("Weight Unit", comment: "Weight unit settings tableView title")

        default: return
        }


        prevItem = NSUserDefaults.standardUserDefaults().integerForKey(key)
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

    private var currentSelectedValue = ""
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath)

        if weightItems.count > 0 {
            cell.textLabel?.text = "\(weightItems[indexPath.row])"
        } else if distanceItems.count > 0 {
            cell.textLabel?.text = "\(distanceItems[indexPath.row])"
        }

        if indexPath.row == prevItem {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        prepareBackSegue(indexPath)
        navigationController?.popToRootViewControllerAnimated(true)
    }

    private func prepareBackSegue(indexPath: NSIndexPath) {
        var item = 0

        let selectedKey = SettingsKeys(rawValue: key)!

        switch selectedKey {
        case .weight:
            item = weightItems[indexPath.row].rawValue
            NSUserDefaults.standardUserDefaults().setInteger(item, forKey: key)

        case .distance:
            item = distanceItems[indexPath.row].rawValue
            NSUserDefaults.standardUserDefaults().setInteger(item, forKey: key)


        default: return
        }

        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
