//
//  RunningWorkoutDelegate.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import UIKit

class RunningWorkoutDelegate: NSObject, UITableViewDelegate {

    init(workoutHandler: RunningWorkoutHandler, responder: ((RunningWorkoutSegueIdentifier, UITableViewCell) -> Void)) {
        self.workoutHandler = workoutHandler
        self.segueResponder = responder
    }

    private var segueResponder: ((RunningWorkoutSegueIdentifier, UITableViewCell) -> Void)

    private var workoutHandler: RunningWorkoutHandler
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)


        let section = RunningWorkoutTableViewSections(currentSection: indexPath.section)

        switch section {
        case .Exercises:
            if indexPath.row == workoutHandler.numberOfPerformedExercises() {
                // Add a new exercise
                segueResponder(RunningWorkoutSegueIdentifier.AddExerciseSegue, cell!)
            } else {
                // Add Sets/ Reps
                let exercise = workoutHandler.exerciseAtIndex(indexPath.row)
                if exercise.type == ExerciseType.Distance.rawValue {
                    segueResponder(RunningWorkoutSegueIdentifier.DistanceExericse, cell!)
                } else {
                    segueResponder(RunningWorkoutSegueIdentifier.WeightExercise, cell!)
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
