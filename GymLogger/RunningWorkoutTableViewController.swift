//
//  RunningWorkoutTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 27.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit


class RunningWorkoutTableViewController: UITableViewController {

    var workoutRoutine: WorkoutRoutineEntity?
    private var runningWorkout: WorkoutEntity!
    var detailWorkout: WorkoutEntity?

    private var initalSetupFinished = false
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        guard let detail = detailWorkout, let running = runningWorkout else {
            return
        }

        let exerciseSection = NSIndexSet(index: RunningWorkoutTableViewSections.Exercises.rawValue)
        tableView.beginUpdates()
        tableView.reloadSections(exerciseSection, withRowAnimation: .Automatic)
        tableView.endUpdates()
    }

    private var runningWorkoutDataSource: RunningWorkoutDataSource!
    private var runningWorkoutDelegate: RunningWorkoutDelegate!
    private var isFreeWorkout = false
    private var isEditingEnabled = true
    override func viewDidLoad() {
        super.viewDidLoad()

        var workoutForSetup: WorkoutEntity
        if let detail = detailWorkout {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit,
                    target: self,
                    action: Selector("editWorkout"))
            navigationItem.leftBarButtonItem = nil

            workoutForSetup = detail
            isEditingEnabled = false
        } else {
            prepareForNewRoutine()
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel,
                    target: self,
                    action: Selector("cancelWorkout:"))

            workoutForSetup = runningWorkout
        }

        runningWorkoutDataSource = RunningWorkoutDataSource(fromWorkout: workoutForSetup,
                editing: isEditingEnabled)

        runningWorkoutDelegate = RunningWorkoutDelegate(runningWorkout: workoutForSetup,
                responder: {
                    (identifier, cell) -> Void in
                    self.performSegueWithIdentifier(identifier.rawValue, sender: cell)
                },
                editing: isEditingEnabled)

        tableView.dataSource = runningWorkoutDataSource
        tableView.delegate = runningWorkoutDelegate
    }

    func editWorkout() -> Void {

    }

    private func prepareForNewRoutine() -> Void {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func finishWorkout(sender: AnyObject) {
        runningWorkout.finishWorkout()

        if context.trySaveOrRollback() {
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    private var context: NSManagedObjectContext {
        return DataCoordinator.sharedInstance.managedObjectContext
    }

    @IBAction func cancelWorkout(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true) {
            self.context.deleteObject(self.runningWorkout)
            self.context.trySaveOrRollback()
        }
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = RunningWorkoutSegueIdentifier(identifier: segue.identifier!)

        var workoutToUse: WorkoutEntity
        if let detail = detailWorkout {
            workoutToUse = detail
        } else {
            workoutToUse = runningWorkout
        }

        switch identifier {
        case .AddExerciseSegue:
            let chooser = ExerciseToWorkoutChooser(workout: workoutToUse)

            let navController = segue.destinationViewController as! UINavigationController
            let destination = navController.viewControllers.first as! ExerciseOverviewTableViewController
            destination.chooserForWorkout = chooser

        case .DistanceExericse:
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let destination = segue.destinationViewController as! DistanceTrackingTableViewController
            destination.exerciseToTrack = workoutToUse.performanceAtIndex(indexPath!.row)
            destination.runningWorkout = workoutToUse
            destination.isEditingEnabled = isEditingEnabled
        case .SetRepsSetsSegue:
            break // TODO!!!

        case .WeightExercise:
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let destination = segue.destinationViewController as! SetsRepsTrackingTableViewController
            destination.isEditingEnabled = isEditingEnabled
            destination.exerciseToTrack = workoutToUse.performanceAtIndex(indexPath!.row)
            destination.runningWorkout = workoutToUse
        }
    }
}
