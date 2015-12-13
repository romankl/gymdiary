//
//  BodyPartChooserTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class BodyPartChooserTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        title = NSLocalizedString("Body Part", comment: "Body Part Title for BodyPartChooserTableViewController - used as a show segue Controller from AddExerciseTableViewController")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private let items = [BodyParts.Chest, BodyParts.Legs, BodyParts.Arms, BodyParts.Back, BodyParts.Shoulder, BodyParts.Abs]

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = "\(items[indexPath.row])"

        return cell
    }

    var exercise: Exercise?
    var isUpdate = false
    private var prevCell: UITableViewCell?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // guard against the case that the vc comes up without a selection
        if let oldCell = prevCell {
            oldCell.accessoryType = .None
        }

        let newCell = tableView.cellForRowAtIndexPath(indexPath)
        newCell?.accessoryType = .Checkmark
        newCell?.selected = false

        prevCell = newCell

        if isUpdate {
            let realm = try! Realm()
            try! realm.write {
                self.exercise?.bodyGroup = self.items[indexPath.row].rawValue
            }
        } else {
            exercise?.bodyGroup = items[indexPath.row].rawValue
        }
    }
}
