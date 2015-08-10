//
//  WorkoutRoutineBuilder.swift
//  GymLogger
//
//  Created by Roman Klauke on 10.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import RealmSwift

public struct WorkoutRoutineBuilder {
    private var realm: Realm!
    private var workoutRoutine: WorkoutRoutine!

    public init(realm: Realm = Realm()) {
        self.realm = realm
    }

    /// Creates the workout routine the realm
    public func create() -> Void {
        self.realm.write {
            self.realm.add(self.workoutRoutine)
        }
    }

    public func addRoutineName(name: String) -> Void {
        workoutRoutine.name = name
    }

    public func exercisesInWorkout() -> Int {
        return workoutRoutine.exercises.count
    }
}
