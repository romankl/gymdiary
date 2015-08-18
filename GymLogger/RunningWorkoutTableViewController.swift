//
//  RunningWorkoutTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 27.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift


class RunningWorkoutTableViewController: BaseOverviewTableViewController {

    var workoutRoutine: WorkoutRoutine?

    private let runningWorkout: Workout = Workout()
    private var workoutHandler: RunningWorkoutHandler!
    private var initalSetupFinished = false
    override func viewWillAppear(animated: Bool) {
        if let routine = workoutRoutine {
            // Initial setup happened already so theres no need
            // to perform it again
            // For the moment it works this way, but later on it should
            // be refactred to something "better"
            if !initalSetupFinished {
                title = routine.name

                workoutHandler = RunningWorkoutHandler(workout: runningWorkout)
                workoutHandler.buildUp(fromRoutine: routine)

                initalSetupFinished = true
            } else {
                tableView.reloadData()
            }
        } else {
            // guard against setting the name again
            // TODO: handle through lifecycle
            if runningWorkout.name.isEmpty {
                runningWorkout.name = NSLocalizedString("Free Workout", comment: "Free wrkout as a cell title in a new workoutcontroller")
            }
        }

        let realm = Realm()
        realm.write {
            realm.add(self.runningWorkout)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        static let weightExercise = "trackSetsReps"
    }

    @IBAction func finishWorkout(sender: UIBarButtonItem) {
        workoutHandler.finishWorkout()
        workoutHandler.calculateWorkoutValues()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelWorkout(sender: UIBarButtonItem) {
        workoutHandler.cancelWorkout()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    // TODO: Implement Comparable

    private enum Sections: Int {
        case MetaInformation = 0, Exercises
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Constants.sections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.Exercises.rawValue {
            return runningWorkout.performedExercises.count + 1
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == runningWorkout.performedExercises.count {
                // Add a new exercise
                performSegueWithIdentifier(Constants.addExerciseSegue, sender: self)
            } else {
                // Add Sets/ Reps
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                let exercise = runningWorkout.performedExercises[indexPath.row].exercise
                if exercise.type == ExerciseType.Distance.rawValue {
                    performSegueWithIdentifier(Constants.distanceExericse, sender: cell)
                } else {
                    performSegueWithIdentifier(Constants.weightExercise, sender: cell)
                }
            }
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.exerciseCellIdentifier, forIndexPath: indexPath) as! UITableViewCell

        if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == runningWorkout.performedExercises.count {
                cell.textLabel?.text = NSLocalizedString("Add Exercise", comment: "...")
            } else {
                cell.textLabel?.text = runningWorkout.performedExercises[indexPath.row].exercise.name
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
                let realm = Realm()
                realm.write {
                    self.runningWorkout.performedExercises.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == runningWorkout.performedExercises.count {
                return false
            }
            return true
        }
        return false
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.addExerciseSegue {
            let chooser = ExerciseToWorkoutChooser(workout: runningWorkout) {
                // TODO:
            }

            let navController = segue.destinationViewController as! UINavigationController
            let destination = navController.viewControllers.first as! ExerciseOverviewTableViewController
            destination.chooserForWorkout = chooser
        } else if segue.identifier == Constants.setRepsSetsSegue || segue.identifier == Constants.distanceExericse {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let destination = segue.destinationViewController as! BaseTrackerTableViewController
            destination.exerciseToTrack = runningWorkout.performedExercises[indexPath!.row]
            destination.runningWorkout = runningWorkout
        }
    }
}
