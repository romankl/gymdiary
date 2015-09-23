//
//  StartNewWorkoutSections.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import UIKit


enum StartNewWorkoutSections: Int {
    case Meta, FreeFormWorkout, WorkoutRoutine

    init(section: Int) {
        switch section {
        case 0: self = .Meta
        case 1: self = .FreeFormWorkout
        case 2: self = .WorkoutRoutine
        default:
            self = .Meta
        }
    }

    func titleHeader() -> String {
        switch self {
        case .Meta: return NSLocalizedString("Workout Date", comment: "Date and time informations for a new workout in startNewWorkout")
        case .FreeFormWorkout: return NSLocalizedString("Free workout", comment: "...")
        case .WorkoutRoutine: return NSLocalizedString("Workout Routine", comment: "...")
        }
    }

    func rowsInSection() -> Int {
        switch self {
        case .Meta, .FreeFormWorkout:
            return 1
        default: return -1
        }
    }

    func titleFooter() -> String {
        switch self {
        case .FreeFormWorkout:
            return NSLocalizedString("Use a free form workout to build a one-time workout without a predefined routine", comment: "Section footer for freeform workout in startNewWorkout")
        case .WorkoutRoutine:
            return NSLocalizedString("Workout routines can be extended by addtional exercises", comment: "section footer for workout routines in startNewWorkout")
        default:
            return ""
        }
    }

    static func numberOfSections(routineCount: Int) -> Int {
        return 3
    }
}
