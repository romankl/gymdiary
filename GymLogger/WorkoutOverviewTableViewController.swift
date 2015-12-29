//
//  WorkoutOverviewTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class WorkoutOverviewTableViewController: BaseOverviewTableViewController {

    private struct Constants {
        static let cellIdentifier = "workoutRoutineCell"
        static let detailSegue = "detail"
        static let addSegue = "add"
    }

    private var items = [WorkoutEntity]()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Workout Routines", comment: "Workout Routine overview Controller title")

        let context = DataCoordinator.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: WorkoutRoutineEntity.entityName)
        fetchRequest.sortDescriptors = WorkoutRoutineEntity.sortDescriptorForNewWorkout()

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath)

        let itemForCell = fetchedResultsController.objectAtIndexPath(indexPath) as! WorkoutRoutineEntity
        cell.textLabel?.text = itemForCell.name

        return cell
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                            forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.beginUpdates()

            let context = DataCoordinator.sharedInstance.managedObjectContext
            let item = fetchedResultsController.objectAtIndexPath(indexPath) as? WorkoutRoutineEntity
            context.deleteObject(item!)
            if context.trySaveOrRollback() {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            tableView.endUpdates()
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.addSegue {

        } else if segue.identifier == Constants.detailSegue {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let destination = segue.destinationViewController as! DetailWorkoutTableViewController
            let routine = fetchedResultsController.objectAtIndexPath(indexPath!) as! WorkoutRoutineEntity

            routine.isInsertObject = false
            destination.detailWorkoutRoutine = routine
        }
    }
}
