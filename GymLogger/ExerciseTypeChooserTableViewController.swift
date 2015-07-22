//
//  ExerciseTypeChooserTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class ExerciseTypeChooserTableViewController: UITableViewController {

    var exercise: Exercise?
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        title = NSLocalizedString("Exercise Type", comment: "Exercise Title in AddExerciseViewController used as a ViewController Title")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    let items = [ExerciseType.Weight, ExerciseType.Distance]
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = "\(items[indexPath.row])"

        return cell
    }


    var oldCell: UITableViewCell?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = oldCell {
            oldCell?.accessoryType = .None
        }

        let newCell = tableView.cellForRowAtIndexPath(indexPath)
        newCell?.selected = false
        newCell?.accessoryType = .Checkmark

        exercise?.type = items[indexPath.row].rawValue
        oldCell = newCell
    }
}
