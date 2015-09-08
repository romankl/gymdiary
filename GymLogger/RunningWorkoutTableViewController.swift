//
//  RunningWorkoutTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 27.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift


class RunningWorkoutTableViewController: UITableViewController {

    var workoutRoutine: WorkoutRoutine?

    private var workoutHandler: RunningWorkoutHandler = RunningWorkoutHandler()
    private var initalSetupFinished = false
    override func viewWillAppear(animated: Bool) {
        if let routine = workoutRoutine {
            // Initial setup happened already so theres no need
            // to perform it again
            // For the moment it works this way, but later on it should
            // be refactred to something "better"
            if !initalSetupFinished {
                title = routine.name

                workoutHandler.buildUp(fromRoutine: routine)

                initalSetupFinished = true
            } else {
                tableView.reloadData()
            }
            isFreeWorkout = false
        } else {
            workoutHandler.prepareForFreeWorkoutUsage()
            isFreeWorkout = true
        }
    }

    private var isFreeWorkout = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // guard against setting the name again
        // TODO: handle through lifecycle
        if workoutHandler.workout.name.isEmpty {
            workoutHandler.setFreeFormName()
        }

        title = workoutHandler.workout.name

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelWorkout:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private struct Constants {
        static let sections = 3
        static let exerciseCellIdentifier = "exerciseCell"
        static let addExerciseSegue = "addExercise"
        static let setRepsSetsSegue = "setStats"
        static let distanceExericse = "trackDistance"
        static let weightExercise = "trackRepsSets"
    }

    @IBAction func finishWorkout(sender: UIBarButtonItem) {
        workoutHandler.finishWorkout()
        workoutHandler.calculateWorkoutValues()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelWorkout(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true) {
            self.workoutHandler.cancelWorkout()
        }
    }

    // TODO: Implement Comparable

    private enum Sections: Int {
        case MetaInformation = 0, Exercises, Summary
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Constants.sections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.Exercises.rawValue {
            return workoutHandler.numberOfPerformedExercises() + 1
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == workoutHandler.numberOfPerformedExercises() {
                // Add a new exercise
                performSegueWithIdentifier(Constants.addExerciseSegue, sender: self)
            } else {
                // Add Sets/ Reps
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                let exercise = workoutHandler.exerciseAtIndex(indexPath.row)
                if exercise.type == ExerciseType.Distance.rawValue {
                    performSegueWithIdentifier(Constants.distanceExericse, sender: cell)
                } else {
                    performSegueWithIdentifier(Constants.weightExercise, sender: cell)
                }
            }
        } else if indexPath.section == Sections.Summary.rawValue {
            let newMode = !tableView.editing
            tableView.setEditing(newMode, animated: true)
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.exerciseCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        cell.accessoryType = .None
        if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == workoutHandler.numberOfPerformedExercises() {
                cell.textLabel?.text = NSLocalizedString("Add Exercise", comment: "...")
            } else {
                let exercise = workoutHandler.exerciseAtIndex(indexPath.row)
                cell.textLabel?.text = exercise.name
                cell.accessoryType = .DisclosureIndicator
            }
        } else if indexPath.section == Sections.MetaInformation.rawValue {
            cell.textLabel?.text = "Meta"
        } else {
            cell.textLabel?.text = "Dummy"
        }

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if indexPath.section == Sections.Exercises.rawValue {
                workoutHandler.removeExerciseAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

                tableView.beginUpdates()
                let set = NSIndexSet(index: Sections.Exercises.rawValue)
                tableView.reloadSections(set, withRowAnimation: .Automatic)
                tableView.endUpdates()
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == workoutHandler.numberOfPerformedExercises() {
                return false
            }
            return true
        }

        return false
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        workoutHandler.swapExercises(sourceIndexPath.row, to: destinationIndexPath.row)
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == workoutHandler.numberOfPerformedExercises() {
                return false
            }
            return true
        }
        return false
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.addExerciseSegue {
            let oldCount = workoutHandler.performedExercises().count
            let chooser = ExerciseToWorkoutChooser(workout: workoutHandler.workout) {
                let newCount = self.workoutHandler.performedExercises().count
                if self.isFreeWorkout {
                    self.tableView.beginUpdates()
                    let indexPath = NSIndexPath(forRow: self.workoutHandler.performedExercises().count - 1, inSection: Sections.Exercises.rawValue)
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()
                }
            }

            let navController = segue.destinationViewController as! UINavigationController
            let destination = navController.viewControllers.first as! ExerciseOverviewTableViewController
            destination.chooserForWorkout = chooser
        } else if segue.identifier == Constants.weightExercise {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let destination = segue.destinationViewController as! SetsRepsTrackingTableViewController
            destination.exerciseToTrack = workoutHandler.performanceAtIndex(indexPath!.row)
            destination.runningWorkout = workoutHandler.workout
        } else if segue.identifier == Constants.distanceExericse {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let destination = segue.destinationViewController as! DistanceTrackingTableViewController
            destination.exerciseToTrack = workoutHandler.performanceAtIndex(indexPath!.row)
            destination.runningWorkout = workoutHandler.workout
        }
    }
}
