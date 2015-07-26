//
//  WorkoutOverviewTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift


class WorkoutOverviewTableViewController: BaseOverviewTableViewController {

    private struct Constants {
        static let cellIdentifier = "workoutRoutineCell"
        static let detailSegue = "detail"
        static let addSegue = "add"
    }

    private var items = Realm().objects(WorkoutRoutine).sorted("name", ascending: true)
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath) as! UITableViewCell

        let itemForCell = items[indexPath.row]
        cell.textLabel?.text = itemForCell.name

        return cell
    }

    override func fetchData() {
        items = Realm().objects(WorkoutRoutine).sorted("name", ascending: true)
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            // Ask for confirmation (Action Sheet?!)
            // Get all the workouts that are based on this one
            // loop through them and delete the relation to this routine
            // delete the routine

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.addSegue {

        } else if segue.identifier == Constants.detailSegue {

        }
    }
}
