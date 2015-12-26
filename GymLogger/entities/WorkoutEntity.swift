//
//  WorkoutEntity.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import Foundation
import CoreData


class WorkoutEntity: BaseEntity {
    static let workoutEntityName = "WorkoutEntity"

    enum Keys: String {
        case startedAt
        case name
        case isActive
    }

    static func sortDescriptorForHistory() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: Keys.startedAt.rawValue, ascending: true)]
    }

}
