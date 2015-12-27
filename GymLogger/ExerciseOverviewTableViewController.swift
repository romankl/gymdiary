//
//  ExerciseOverviewTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class ExerciseOverviewTableViewController: BaseOverviewTableViewController {

    private struct Constants {
        static let cellIdentifier = "exerciseCell"
    }

    var chooserForRoutine: ExerciseChooserForRoutine?
    // Chooser for a workoutRoutine
    var chooserForWorkout: ExerciseToWorkoutChooser?
    // Chooser for a running workout
    override func viewDidLoad() {
        super.viewDidLoad()

        let context = DataCoordinator.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: ExerciseEntity.entityName)
        fetchRequest.sortDescriptors = ExerciseEntity.sortDescriptorsForOverview()

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)

        // used to fit it in one if
        if (chooserForRoutine != nil) || (chooserForWorkout != nil) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelChooser"))
            title = NSLocalizedString("Choose an exercise", comment: "Exercise chooser reached from new workout routine cntroller")
        } else {
            title = NSLocalizedString("Exercises", comment: "Exercise overview")
        }
    }

    func doneWithChooser() -> Void {
        if let chooser = chooserForWorkout {
            if let exercise = self.selectedExercise {
                /*
                              let settingsValueForSets = ROKKeyValue.getInt(SettingsKeys.defaultSets, defaultValue: 5)
                              let planedSets = settingsValueForSets > 0 ? settingsValueForSets : 5 // TODO: Decide
                              let settingsValueForReps = ROKKeyValue.getInt(SettingsKeys.defaultReps, defaultValue: 5)
                              let planedReps = settingsValueForReps > 0 ? settingsValueForReps : 5 // TODO: Decide


                              let performanceMap = PerformanceExerciseMap()
                              for var i = 0; i < planedSets; i++ {
                                  let performance = Performance()
                                  performance.preReps = planedReps
                                  performanceMap.detailPerformance.append(performance)

                                  if exercise.type == ExerciseType.Distance.rawValue {
                                      break
                                  }
                              }
                              let workout = chooser.runningWorkout

                              let context = DataCoordinator.sharedInstance.managedObjectContext
                              let performanceMap = PerformanceExerciseMapEntity.prepareMapping(order: 0,
                                      exercise: exercise,
                                      context: context,
                                      workout: workout)
                              performanceMap.buildUp()
              */

                //    performanceMap.exercise = exercise
                //             self.chooserForWorkout?.runningWorkout.performedExercises.append(performanceMap)
                // TODO: Missing defaultReps/defaultSets

                let context = DataCoordinator.sharedInstance.managedObjectContext
                chooser.runningWorkout.addExercise(selectedExercise!, context: context)
                if context.trySaveOrRollback() {
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: self.chooserForWorkout!.completion)
                }
            }
        } else if let chooser = chooserForRoutine {
            let context = DataCoordinator.sharedInstance.managedObjectContext

            chooserForRoutine?.workoutRoutine.appendExercise(selectedExercise!, context: context)
            context.trySaveOrRollback()
            presentingViewController?.dismissViewControllerAnimated(true, completion: chooserForRoutine?.completion)
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

    private func markCellAndSetExercise(indexPath: NSIndexPath) {
        selectedExercise = fetchedResultsController.objectAtIndexPath(indexPath) as? ExerciseEntity
        doneWithChooser()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = SegueIdentifier(rawValue: segue.identifier!)!
        switch identifier {
        case .DetailSegue:
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let exercise = fetchedResultsController.objectAtIndexPath(indexPath!) as! ExerciseEntity
            let destination = segue.destinationViewController as! AddExerciseTableViewController
            destination.exercise = exercise
            break
        case .AddSegue:
            break
        }
    }

}
