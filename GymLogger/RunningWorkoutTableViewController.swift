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

        runningWorkoutDataSource = RunningWorkoutDataSource(workoutHandler: workoutHandler)
        tableView.dataSource = runningWorkoutDataSource

        runningWorkoutDelegate = RunningWorkoutDelegate(workoutHandler: workoutHandler,
                responder: {
                    (identifier, cell) -> Void in
                    self.performSegueWithIdentifier(identifier.rawValue, sender: cell)
                })
        tableView.delegate = runningWorkoutDelegate
    }

    private var runningWorkoutDataSource: RunningWorkoutDataSource!
    private var runningWorkoutDelegate: RunningWorkoutDelegate!
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

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = RunningWorkoutSegueIdentifier(identifier: segue.identifier!)

        switch identifier {
        case .AddExerciseSegue:
            let chooser = ExerciseToWorkoutChooser(workout: workoutHandler.workout) {
            } // TODO: Refactor

            let navController = segue.destinationViewController as! UINavigationController
            let destination = navController.viewControllers.first as! ExerciseOverviewTableViewController
            destination.chooserForWorkout = chooser

        case .DistanceExericse:
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let destination = segue.destinationViewController as! DistanceTrackingTableViewController
            destination.exerciseToTrack = workoutHandler.performanceAtIndex(indexPath!.row)
            destination.runningWorkout = workoutHandler.workout

        case .SetRepsSetsSegue:
            break // TODO!!!

        case .WeightExercise:
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let destination = segue.destinationViewController as! SetsRepsTrackingTableViewController
            destination.exerciseToTrack = workoutHandler.performanceAtIndex(indexPath!.row)
            destination.runningWorkout = workoutHandler.workout
        }
    }
}
