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

    var segueTrigger: ((identifier:String) -> Void)

    @objc func tableView(tableView: UITableView,
                         didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if section == DetailWorkoutSections.Exercises {
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
        }
    }

}
