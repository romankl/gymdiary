//
//  ExerciseOverviewTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class ExerciseOverviewTableViewController: ExerciseFilterTableViewController {

    private struct Constants {
        static let cellIdentifier = "exerciseCell"
    }


    var exerciseFilterPredicate: NSPredicate?
    override func viewDidLoad() {
        super.viewDidLoad()

        let context = DataCoordinator.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: ExerciseEntity.entityName)

        fetchRequest.sortDescriptors = ExerciseEntity.sortDescriptorsForOverview()

        if let predicate = exerciseFilterPredicate {
            fetchRequest.predicate = predicate
        }

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: ExerciseEntity.Keys.bodyGroupSectionIdentifer.rawValue,
                cacheName: nil)

        // used to fit it in one if
        if (chooserForRoutine != nil) || (chooserForWorkout != nil) {
            title = NSLocalizedString("Choose an exercise", comment: "Exercise chooser reached from new workout routine cntroller")
            navigationItem.leftBarButtonItem = nil
        } else {
            title = NSLocalizedString("Exercises", comment: "Exercise overview")
            let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ExerciseOverviewTableViewController.addExercise))
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItems = [self.editButtonItem(), addButton]
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return super.numberOfSectionsInTableView(tableView)
        }


        guard let fetchController = fetchedResultsController else {
            return 1
        }

        guard let sections = fetchController.sections else {
            return 1
        }
        return sections.count;
    }

    func doneWithChooser() -> Void {
        if let chooser = chooserForWorkout {
            if let _ = self.selectedExercise {
                let context = DataCoordinator.sharedInstance.managedObjectContext
                chooser.runningWorkout.addExercise(selectedExercise!, context: context)
                if context.trySaveOrRollback() {
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        } else if let _ = chooserForRoutine {
            let context = DataCoordinator.sharedInstance.managedObjectContext

            chooserForRoutine?.workoutRoutine.appendExercise(selectedExercise!, context: context)
            context.trySaveOrRollback()
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func cancelChooser() -> Void {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private var selectedExercise: ExerciseEntity?

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let _ = chooserForRoutine {
            markCellAndSetExercise(indexPath)
        } else if let _ = chooserForWorkout {
            markCellAndSetExercise(indexPath)
        } else {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            performSegueWithIdentifier(SegueIdentifier.DetailSegue.rawValue, sender: cell)
        }
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, titleForHeaderInSection section:
            Int) ->
            String? {
        guard let fetchController = fetchedResultsController else {
            return ""
        }

        let fetchedSection = fetchController.sections![section]
        return fetchedSection.name
    }

    private func markCellAndSetExercise(indexPath: NSIndexPath) {
        if searchController.active && searchController.searchBar.text != "" {
            selectedExercise = foundExercises[indexPath.row]
        } else {
            selectedExercise = fetchedResultsController.objectAtIndexPath(indexPath) as? ExerciseEntity
        }

        doneWithChooser()
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }

        guard let fetchController = fetchedResultsController else {
            return 0
        }

        guard let sections = fetchController.sections else {
            return 0
        }

        var rows = 0

        if sections.count > 0 {
            rows = sections[section].numberOfObjects
        }
        return rows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if searchController.active && searchController.searchBar.text != "" {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }


        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath)
        let itemForCell = fetchedResultsController.objectAtIndexPath(indexPath) as! ExerciseEntity
        cell.textLabel?.text = itemForCell.name

        if let _ = chooserForRoutine {
            cell.accessoryType = .None

        } else if let _ = chooserForWorkout {
            cell.accessoryType = .None

        } else {
            cell.accessoryType = .DisclosureIndicator

        }

        return cell
    }

    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                            forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.beginUpdates()
            let context = DataCoordinator.sharedInstance.managedObjectContext
            let item = fetchedResultsController.objectAtIndexPath(indexPath) as! ExerciseEntity
            context.deleteObject(item)
            context.trySaveOrRollback()

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

            tableView.endUpdates()
        }
    }

    enum SegueIdentifier: String {
        case DetailSegue = "detailSegue"
        case AddSegue = "addExercise"
    }

    func addExercise() -> Void {
        self.performSegueWithIdentifier(SegueIdentifier.AddSegue.rawValue, sender: nil)
    }

// In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = SegueIdentifier(rawValue: segue.identifier!)!
        switch identifier {
        case .DetailSegue:
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let exercise = fetchedResultsController.objectAtIndexPath(indexPath!) as! ExerciseEntity
            let destination = segue.destinationViewController as! AddExerciseTableViewController

            // if we select a new exercise, it could be possible that the exercise is still
            // marked as a new object.
            exercise.isInsertObject = false

            destination.exercise = exercise
            break
        case .AddSegue:
            break
        }
    }

}
