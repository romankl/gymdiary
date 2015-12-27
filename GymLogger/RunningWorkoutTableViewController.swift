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

    var workoutRoutine: WorkoutRoutineEntity?
    private var runningWorkout: WorkoutEntity!


    private var initalSetupFinished = false
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let exerciseSection = NSIndexSet(index: RunningWorkoutTableViewSections.Exercises.rawValue)
        tableView.beginUpdates()
        tableView.reloadSections(exerciseSection, withRowAnimation: .Automatic)
        tableView.endUpdates()
    }

    private var runningWorkoutDataSource: RunningWorkoutDataSource!
    private var runningWorkoutDelegate: RunningWorkoutDelegate!
    private var isFreeWorkout = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = DataCoordinator.sharedInstance.managedObjectContext

        if let routine = workoutRoutine {
            // Initial setup happened already so theres no need
            // to perform it again
            // For the moment it works this way, but later on it should
            // be refactred to something "better"
            if !initalSetupFinished {
                title = routine.name

                runningWorkout = WorkoutEntity.prepareWorkout(NSDate(),
                        fromRoutine: routine,
                        inContext: context)

                runningWorkout.buildUp(5, plannedReps: 5) // TODO: Extract to NSUserDefaults

                initalSetupFinished = true
            } else {
                tableView.reloadData()
            }
            isFreeWorkout = false
        } else {
            runningWorkout = WorkoutEntity.prepareForFreeWorkoutUsage(context)
            isFreeWorkout = true

            title = runningWorkout.name
        }

        context.trySaveOrRollback()

        runningWorkoutDataSource = RunningWorkoutDataSource(fromWorkout: runningWorkout)
        tableView.dataSource = runningWorkoutDataSource

        runningWorkoutDelegate = RunningWorkoutDelegate(runningWorkout: runningWorkout,
                responder: {
                    (identifier, cell) -> Void in
                    self.performSegueWithIdentifier(identifier.rawValue, sender: cell)
                })
        tableView.delegate = runningWorkoutDelegate

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelWorkout:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func finishWorkout(sender: AnyObject) {
        runningWorkout.finishWorkout()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelWorkout(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true) {
            let context = DataCoordinator.sharedInstance.managedObjectContext
            context.deleteObject(self.runningWorkout)
            context.trySaveOrRollback()
        }
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = RunningWorkoutSegueIdentifier(identifier: segue.identifier!)

        switch identifier {
        case .AddExerciseSegue:
            let chooser = ExerciseToWorkoutChooser(workout: runningWorkout) {
            } // TODO: Refactor

            let navController = segue.destinationViewController as! UINavigationController
            let destination = navController.viewControllers.first as! ExerciseOverviewTableViewController
            destination.chooserForWorkout = chooser

        case .DistanceExericse:
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let destination = segue.destinationViewController as! DistanceTrackingTableViewController
                // destination.exerciseToTrack = runningWorkout.performanceAtIndex(indexPath!.row)
                //destination.runningWorkout = runningWorkout

        case .SetRepsSetsSegue:
            break // TODO!!!

        case .WeightExercise:
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let destination = segue.destinationViewController as! SetsRepsTrackingTableViewController
            destination.exerciseToTrack = runningWorkout.performanceAtIndex(indexPath!.row)
            destination.runningWorkout = runningWorkout
        }
    }
}
