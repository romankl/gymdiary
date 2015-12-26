//
//  WorkoutRoutineEntity.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import Foundation
import CoreData


class WorkoutRoutineEntity: BaseEntity {

    static let entityName = "WorkoutRoutineEntity"

    enum Keys: String {
        case name
        case isActive
        case isArchived
    }

    static func sortDescriptorForNewWorkout() -> [NSSortDescriptor] {
        let sortDescriptor = NSSortDescriptor(key: Keys.name.rawValue, ascending: true)
        return [sortDescriptor]
    }

    static func predicateForRoutines(archived: Bool = false) -> NSPredicate {
        let predicate = NSPredicate(format: "%K == %@", Keys.isArchived.rawValue, archived)
        return predicate
    }

}
