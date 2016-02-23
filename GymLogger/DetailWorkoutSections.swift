//
// Created by Roman Klauke on 22.12.15.
// Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

enum DetailWorkoutSections: Int {
    case BaseInformations = 0, Exercises, Notes, Actions


    init(currentSection: Int) {
        switch currentSection {
        case 0: self = .BaseInformations
        case 1: self = .Exercises
        case 2: self = .Notes
        case 3: self = .Actions
        default:
            self = .BaseInformations // just to get rid of the warning
        }
    }

    func numberOfRowsInSection() -> Int {
        switch self {
        case .BaseInformations: return 2
        case .Notes: return 1
        case .Actions: return 2
        default: return -1
        }
    }

    func canEditRows() -> Bool {
        switch self {
        case .BaseInformations, .Notes, .Actions: return false
        case .Exercises: return true
        }
    }

    func canMoveRows() -> Bool {
        switch self {
        case .Exercises: return true
        default: return false
        }
    }

    func footerForSection() -> String {
        switch self {
        case .Actions: return NSLocalizedString("Use the \"Hide From Workout\" action to hide the routine from the new workout selection. " +
                "It\'s not removed; to undo this action tap \"Show In Workouts\"." +
                "The \"Delete Routine\" action to remove this routine from the database. This action is permanent; existing workouts aren\'t effected",
                comment: "Actions for detailWorkouts")
        default:
            return ""
        }
    }

    static func numberOfSectionsInDetailView() -> Int {
        return 4
    }

    static func numberOfSectionsInCreationView() -> Int {
        return 3 // hides the action section
    }
}

enum DetailWorkoutActionSections: Int {
    case DeleteAction = 0, ArchiveAction

    init(currentRow: Int) {
        switch currentRow {
        case 0: self = .DeleteAction
        case 1: self = .ArchiveAction

        default:
            self = .DeleteAction
        }
    }

    func textForCell() -> String {
        switch self {
        case .DeleteAction: return NSLocalizedString("Delete Routine",
                comment: "Caption for the delete action in detailWorkoutRoutines")
        case .ArchiveAction: return NSLocalizedString("Hide From Workout", comment: "Caption for the archive action in the workoutRoutine@")
        }
    }
}
