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

    private var foundWorkouts = try! Realm().objects(WorkoutRoutine).sorted("name", ascending: true)
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()

        title = NSLocalizedString("Workout Routines", comment: "Workout Routine overview Controller title")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundWorkouts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath) 

        let itemForCell = foundWorkouts[indexPath.row]
        cell.textLabel?.text = itemForCell.name

        return cell
    }

    override func fetchData() {
        do {
            foundWorkouts = try Realm().objects(WorkoutRoutine).sorted("name", ascending: true)
        } catch _ as NSError {

        }
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = foundWorkouts[indexPath.row]
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(item)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            } catch _ as NSError {
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.addSegue {

        } else if segue.identifier == Constants.detailSegue {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let destination = segue.destinationViewController as! DetailWorkoutTableViewController
            destination.detailWorkoutRoutine = foundWorkouts[indexPath!.row]
        }
    }
}
