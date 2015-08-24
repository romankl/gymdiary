//
//  SetsRepsTrackingTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 17.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class SetsRepsTrackingTableViewController: BaseTrackerTableViewController {

    private struct Constants {
        static let metaCellIdentifier = "metaCell"
        static let repsSetsIdentifier = "repsCell"
        static let setsControllingCell = "setsController"
    }

    private enum Sections: Int {
        case Meta, RepsSets
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.Meta.rawValue {
            // meta
            return 1
        }
        return exerciseToTrack!.detailPerformance.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == Sections.Meta.rawValue {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.metaCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
            return cell
        } else if indexPath.section == Sections.RepsSets.rawValue {
            if indexPath.row == exerciseToTrack!.detailPerformance.count {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.setsControllingCell, forIndexPath: indexPath) as! UITableViewCell
                cell.textLabel?.text = NSLocalizedString("Add another set", comment: "Add a new set in the weightExercise ViewController")
                return cell
            }

            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.repsSetsIdentifier, forIndexPath: indexPath) as! UITableViewCell
            return cell
        }

        return UITableViewCell() // Silence the warning
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == Sections.Meta.rawValue {
            return false
        }
        return true
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == Sections.RepsSets.rawValue {
            if indexPath.row == exerciseToTrack!.detailPerformance.count {
                let realm = Realm()

                realm.write {
                    let performance = Performance()
                    self.exerciseToTrack!.detailPerformance.append(performance)
                    self.tableView.reloadData()
                }
            }
        }
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
}