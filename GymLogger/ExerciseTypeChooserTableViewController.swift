//
//  ExerciseTypeChooserTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class ExerciseTypeChooserTableViewController: UITableViewController {

    var exercise: ExerciseEntity!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        title = NSLocalizedString("Exercise Type", comment: "Exercise Title in AddExerciseViewController used as a ViewController Title")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    let items = ExerciseType.allTypes()
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.accessoryType = .None

        if items[indexPath.row].rawValue == exercise.type {
            cell.accessoryType = .Checkmark
            oldCell = cell
        }

        cell.textLabel?.text = "\(items[indexPath.row])"

        return cell
    }


    var oldCell: UITableViewCell?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = oldCell {
            oldCell?.accessoryType = .None
        }

        let newCell = tableView.cellForRowAtIndexPath(indexPath)
        newCell?.selected = false
        newCell?.accessoryType = .Checkmark

        exercise.type = self.items[indexPath.row].rawValue
        oldCell = newCell
    }
}
