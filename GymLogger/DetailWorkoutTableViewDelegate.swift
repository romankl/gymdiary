//
// Created by Roman Klauke on 22.12.15.
// Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit

class DetailWorkoutTableViewDelegate: NSObject, UITableViewDelegate {
    private var routine: WorkoutRoutineEntity
    private var tableView: UITableView!

    var isEditing = false

    init(routine: WorkoutRoutineEntity,
         tableView: UITableView,
         segueTriger: ((identifier:String) -> Void)) {
        self.tableView = tableView
        self.segueTrigger = segueTriger
        self.routine = routine
    }

    private var segueTrigger: ((identifier:String) -> Void)
    var actionCallback: ((action:DetailWorkoutDelegateAction) -> Void)?

    @objc func tableView(tableView: UITableView,
                         didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch section {
        case .Exercises:
            if !routine.isInsertObject {
                let exerciseCount = routine.countOfExercises()
                if (indexPath.row == exerciseCount) && isEditing {
                    segueTrigger(identifier: DetailWorkoutConstants.AddExerciseSegue.rawValue)
                }
            } else {
                if indexPath.row == routine.countOfExercises() {
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
