//
//  RunningWorkoutTableViewSections.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import UIKit


enum RunningWorkoutTableViewSections: Int {
    case Meta = 0, Exercises, Notes

    init(currentSection: Int) {
        switch currentSection {
        case 0: self = .Meta
        case 1: self = .Exercises
        case 2: self = .Notes
        default:
            self = .Exercises
        }
    }

    func numberOfRowsInSection() -> Int {
        switch self {
        case .Meta, .Notes: return 1
        default:
            return -1
        }
    }

    func canEditRows() -> Bool {
        switch self {
        case .Meta, .Notes: return false
        case .Exercises: return true
        }
    }

    func headerForSection() -> String {
        switch self {
        case .Meta: return NSLocalizedString("About This Workout", comment: "Running workout tableViewController meta cell identifier")
        case .Exercises: return NSLocalizedString("Exercises", comment: "Exercises in tableViewController (RunningWorkout)")
        case .Notes: return NSLocalizedString("Notes", comment: "Notes about the running workout")
        }
    }

    static func numberOfSections() -> Int {
        return 3
    }
}
