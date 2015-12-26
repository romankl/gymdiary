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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let context = DataCoordinator.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: WorkoutEntity.workoutEntityName)
        fetchRequest.sortDescriptors = WorkoutEntity.sortDescriptorForHistory()

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath)
        // TODO: Replace with something more ...
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as? WorkoutEntity
        cell.textLabel?.text? = (item!.name)!

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = DataCoordinator.sharedInstance.managedObjectContext

            let item = fetchedResultsController.objectAtIndexPath(indexPath) as? WorkoutEntity
            if let workout = item {
                context.delete(item)
                context.trySaveOrFail()

                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.detailSegue {

        }
    }
}
