//
//  WorkoutHistoryTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 01.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class WorkoutHistoryTableViewController: FetchControllerBase {

    private struct Constants {
        static let cellIdentifier = "historyCell"
        static let detailSegue = "showDetail"
    }

    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let context = DataCoordinator.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: WorkoutEntity.workoutEntityName)
        fetchRequest.sortDescriptors = WorkoutEntity.sortDescriptorForHistory()

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: WorkoutEntity.Keys.weekOfYear.rawValue,
                cacheName: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @available(iOS 2.0, *) override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return nil
    }

    @available(iOS 2.0, *) override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let fetchController = fetchedResultsController else {
            return 0
        }

        guard let sections = fetchController.sections else {
            return 0
        }

        return sections.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath)
        // TODO: Replace with something more ...
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as? WorkoutEntity
        cell.textLabel?.text? = item!.name!

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.beginUpdates()

            let context = DataCoordinator.sharedInstance.managedObjectContext

            let item = fetchedResultsController.objectAtIndexPath(indexPath) as? WorkoutEntity
            if let workout = item {
                if let performance = workout.performedExercises?.array as? [PerformanceExerciseMapEntity] {
                    // decrement the usage count of each exercise
                    for detailPerformance in performance {
                        detailPerformance.exercise!.used = Int(detailPerformance.exercise!.used!) - 1
                    }
                }

                context.deleteObject(workout)
                context.trySaveOrFail()

                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }

            tableView.endUpdates()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.detailSegue {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)

            let item = fetchedResultsController.objectAtIndexPath(indexPath!) as! WorkoutEntity

            let destination = segue.destinationViewController as! RunningWorkoutTableViewController
            destination.detailWorkout = item
        }
    }
}
