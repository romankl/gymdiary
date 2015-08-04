//
//  BaseChooserTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 04.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class BaseChooserTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var items = [AnyObject]()
    var key: String!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = "\(items[indexPath.row])"

        return cell
    }

    // Abstract
    func textForCell(indexPath: NSIndexPath) -> String {
        return ""
    }

    func prepareBackSegue(indexPath: NSIndexPath) {

    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        prepareBackSegue(indexPath)
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
