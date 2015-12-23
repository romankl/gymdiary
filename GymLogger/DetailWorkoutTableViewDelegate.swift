//
// Created by Roman Klauke on 22.12.15.
// Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit

class DetailWorkoutTableViewDelegate: NSObject, UITableViewDelegate {
    private var routineBuilder: WorkoutRoutineBuilder?
    private var detailWorkoutRoutine: WorkoutRoutine?
    private var tableView: UITableView!

    var isEditing = false

    init(routineBuilder builder: WorkoutRoutineBuilder,
         detailRoutine: WorkoutRoutine?,
         tableView: UITableView,
         segueTriger: ((identifier:String) -> Void)) {
        self.tableView = tableView
        self.detailWorkoutRoutine = detailRoutine
        self.routineBuilder = builder
        self.segueTrigger = segueTriger
    }

    private var segueTrigger: ((identifier:String) -> Void)
    var actionCallback: ((action:DetailWorkoutDelegateAction) -> Void)?

    @objc func tableView(tableView: UITableView,
                         didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch section {
        case .Exercises:
            if let detail = detailWorkoutRoutine {
                let exerciseCount = detail.exercises.count
                if (indexPath.row == exerciseCount) && isEditing {
                    segueTrigger(identifier: DetailWorkoutConstants.AddExerciseSegue.rawValue)
                }
            } else if let builder = routineBuilder {
                if indexPath.row == builder.exercisesInWorkout() {
                    segueTrigger(identifier: DetailWorkoutConstants.AddExerciseSegue.rawValue)
                }
            }
        case .Actions:
            let row = DetailWorkoutActionSections(currentRow: indexPath.row)
            switch row {
            case .DeleteAction:
                if let cb = actionCallback {
                    cb(action: .Delete)
                }
            case .ArchiveAction:
                if let cb = actionCallback {
                    cb(action: .Archive)
                }
            }
        default:
            return
        }
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


enum DetailWorkoutDelegateAction {
    case Archive, Delete
}
