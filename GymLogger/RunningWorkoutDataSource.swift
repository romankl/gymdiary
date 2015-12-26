//
//  RunningWorkoutDataSource.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import UIKit

class RunningWorkoutDataSource: NSObject, UITableViewDataSource {

    private struct Constants {
        static let exerciseCellIdentifier = "exerciseCell"
        static let metaCellIdentifier = "metaCell"
        static let notesCellIdentifier = "notesCell"
    }

    init(fromWorkout workout: WorkoutEntity) {
        self.runningWorkout = workout
    }

    private var runningWorkout: WorkoutEntity
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return RunningWorkoutTableViewSections.numberOfSections()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let convertedSection = RunningWorkoutTableViewSections(currentSection: section)
        switch convertedSection {
        case .Meta, .Notes: return convertedSection.numberOfRowsInSection()
        case .Exercises: return runningWorkout.numberOfPerformedExercises()! + 1
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let convertedSection = RunningWorkoutTableViewSections(currentSection: section)
        return convertedSection.headerForSection()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = RunningWorkoutTableViewSections(currentSection: indexPath.section)

        switch section {
        case .Meta:
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.metaCellIdentifier, forIndexPath: indexPath)
            return cell
        case .Exercises:
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.exerciseCellIdentifier, forIndexPath: indexPath)
            cell.accessoryType = .None

            if indexPath.row == runningWorkout.numberOfPerformedExercises() {
                cell.textLabel?.text = NSLocalizedString("Add Exercise", comment: "...")
            } else {
                let exercise = runningWorkout.exerciseAtIndex(indexPath.row)
                cell.textLabel?.text = exercise.name
                cell.accessoryType = .DisclosureIndicator
            }
            return cell
        case .Notes:
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.notesCellIdentifier, forIndexPath: indexPath)
            return cell
        }
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let section = RunningWorkoutTableViewSections(currentSection: indexPath.section)
            switch section {
            case .Exercises:
                runningWorkout.removeExerciseAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

                tableView.beginUpdates()
                let set = NSIndexSet(index: section.rawValue)
                tableView.reloadSections(set, withRowAnimation: .Automatic)
                tableView.endUpdates()
            default: break

            }
        }
    }

    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return isEditingPossible(indexPath)
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        runningWorkout.swapExercises(sourceIndexPath.row, to: destinationIndexPath.row)
    }


    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return isEditingPossible(indexPath)
    }

    /// Checks if it is possible to editing the current row
    /// only the "real" exercise rows allow editing - others are locked
    ///
    /// :returns: true if the row is an exercise
    private func isEditingPossible(indexPath: NSIndexPath) -> Bool {
        let section = RunningWorkoutTableViewSections(currentSection: indexPath.section)
        let canEdit = section.canEditRows()
        if canEdit && (indexPath.row == runningWorkout.numberOfPerformedExercises()) {
            return false
        }

        return canEdit
    }
}
