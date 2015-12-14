//
//  StartNewWorkoutDelegate.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class StartNewWorkoutDelegate: NSObject, UITableViewDelegate {
    var selectedRoutine: WorkoutRoutine?


    private var items: Results<WorkoutRoutine>
    private var responder: ((UITableViewCell) -> Void)
    init(items: Results<WorkoutRoutine>, segueResponder: ((UITableViewCell) -> Void)) {
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