//
//  RunningWorkoutDelegate.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import UIKit

class RunningWorkoutDelegate: NSObject, UITableViewDelegate {

    init(runningWorkout: WorkoutEntity,
         responder: ((RunningWorkoutSegueIdentifier, UITableViewCell) -> Void),
         editing: Bool) {
        self.runningWorkout = runningWorkout
        self.segueResponder = responder
        self.isEditingEnabled = editing
    }

    var isEditingEnabled = true
    private var runningWorkout: WorkoutEntity
    private var segueResponder: ((RunningWorkoutSegueIdentifier, UITableViewCell) -> Void)

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)


        let section = RunningWorkoutTableViewSections(currentSection: indexPath.section)

        switch section {
        case .Exercises:
            if indexPath.row == runningWorkout.numberOfPerformedExercises() {
                // Add a new exercise
                segueResponder(RunningWorkoutSegueIdentifier.AddExerciseSegue, cell!)
            } else {
                // Add Sets/ Reps
                if let exercise = runningWorkout.exerciseAtIndex(indexPath.row) {
                    if exercise.type == ExerciseType.Distance.rawValue {
                        segueResponder(RunningWorkoutSegueIdentifier.DistanceExericse, cell!)
                    } else {
                        segueResponder(RunningWorkoutSegueIdentifier.WeightExercise, cell!)
                    }
                }
            }
        default:
            break
        }
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
