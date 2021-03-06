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

        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle

        title = NSLocalizedString("Workout Routines", comment: "Workout Routine overview Controller title")

        let context = DataCoordinator.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: WorkoutRoutineEntity.entityName)
        fetchRequest.sortDescriptors = WorkoutRoutineEntity.sortDescriptorForNewWorkout()

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: WorkoutRoutineEntity.Keys.firstCharOfName.rawValue,
                cacheName: nil)


        definesPresentationContext = true

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        self.tableView.tableHeaderView = searchController.searchBar
    }

    let searchController = UISearchController(searchResultsController: nil)
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return 1
        }


        guard let fetchController = fetchedResultsController else {
            return 0
        }

        guard let sections = fetchController.sections else {
            return 0
        }
        return sections.count
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return foundWorkouts.count
        }

        return super.tableView(tableView, numberOfRowsInSection: section)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    private let dateFormatter = NSDateFormatter()
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath:
        indexPath) as? WorkoutOverviewTableViewCell else {
            return UITableViewCell()
        }

        var itemForCell: WorkoutRoutineEntity
        if searchController.active && searchController.searchBar.text != "" {
            itemForCell = foundWorkouts[indexPath.row]
            cell.titleLabel.text = itemForCell.name
        } else {
            itemForCell = fetchedResultsController.objectAtIndexPath(indexPath) as! WorkoutRoutineEntity
            cell.titleLabel.text = itemForCell.name
        }

        guard let workoutColor = itemForCell.color else {
            return cell
        }

        guard let colorForWorkout = NSKeyedUnarchiver.unarchiveObjectWithData(workoutColor) as? UIColor
        else {
            return cell
        }

        if !itemForCell.name!.isEmpty {
            let index = itemForCell.name!.startIndex.advancedBy(0)
            cell.shortWorkoutName.text = "\(itemForCell.name![index])"
        }
        
        if let lastUsed = itemForCell.lastTimeUsed {
            cell.subTitle.text = NSLocalizedString("Last usage: ", comment: "Last usage: ") + dateFormatter
            .stringFromDate(lastUsed)
        } else {
            cell.subTitle.text = NSLocalizedString("Never", comment: "never")

        }


        cell.color = colorForWorkout

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

    private var foundWorkouts = [WorkoutRoutineEntity]()
    func searchWorkout(searchText: String, scope: String = "All") -> Void {
        let context = DataCoordinator.sharedInstance.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: WorkoutRoutineEntity.entityName)
        fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", WorkoutRoutineEntity.Keys.name.rawValue,
                searchText)
        fetchRequest.sortDescriptors = WorkoutRoutineEntity.sortDescriptorForNewWorkout()

        do {
            let result = try context.executeFetchRequest(fetchRequest)
            foundWorkouts = result as! [WorkoutRoutineEntity]
            tableView.reloadData()
        } catch {
        }
    }
}

extension WorkoutOverviewTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchWorkout(searchController.searchBar.text!)
    }
}
