//
//  StartNewWorkoutDelegate.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import UIKit

class StartNewWorkoutDelegate: NSObject, UITableViewDelegate {
    var selectedRoutine: WorkoutRoutineEntity?


    @objc func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) ->
            CGFloat {
        let section = StartNewWorkoutSections(section: indexPath.section)
        switch section {
            case .WorkoutRoutine: return 68
        default: return 45
        }
    }

    var items: [WorkoutRoutineEntity]
    private var responder: ((UITableViewCell) -> Void)
    init(items: [WorkoutRoutineEntity], segueResponder: ((UITableViewCell) -> Void)) {
        self.items = items
        self.responder = segueResponder
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let section = StartNewWorkoutSections(section: indexPath.section)

        selectedRoutine = nil

        switch section {
        case .FreeFormWorkout, .WorkoutRoutine:
            let cell = tableView.cellForRowAtIndexPath(indexPath)

            if section == .WorkoutRoutine {
                selectedRoutine = items[indexPath.row]
            }

            responder(cell!)
        default:
            fatalError()
        }
    }
}
