//
//  RunningWorkoutHandler.swift
//  GymLogger
//
//  Created by Roman Klauke on 10.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import RealmSwift

public struct RunningWorkoutHandler {
    var workout: Workout!
    private var realm: Realm!

    public init(realm: Realm = try! Realm()) {
        self.workout = Workout()
        self.realm = realm

        try! self.realm.write {
            self.realm.add(self.workout)
        }
    }

    public func prepareForFreeWorkoutUsage() -> Void {
        realm.beginWrite()
        workout.name = NSLocalizedString("Free Workout", comment: "Free wrkout as a cell title in a new workoutcontroller")
        workout.active = true
        try! realm.commitWrite()
    }

    /// Builds the workout based on the given `routine` and
    /// the current keyValue settings
    ///
    /// :params: fromRoutine the template routine that should be used as a reference
    public func buildUp(fromRoutine routine: WorkoutRoutine) -> Void {
        realm.beginWrite()
        workout.name = routine.name
        workout.active = true

        let settingsValueForSets = ROKKeyValue.getInt(SettingsKeys.defaultSets, defaultValue: 5)
        let planedSets = settingsValueForSets > 0 ? settingsValueForSets : 5 // TODO: Decide
        let settingsValueForReps = ROKKeyValue.getInt(SettingsKeys.defaultReps, defaultValue: 5)
        let planedReps = settingsValueForReps > 0 ? settingsValueForReps : 5 // TODO: Decide
        for exercise in routine.exercises {
            let performanceMap = PerformanceExerciseMap()

            for var i = 0; i < planedSets; i++ {
                let performance = Performance()
                performance.preReps = planedReps
                performanceMap.detailPerformance.append(performance)

                if exercise.type == ExerciseType.Distance.rawValue {
                    break
                }
            }

            performanceMap.exercise = exercise
            workout.performedExercises.append(performanceMap)
        }
        workout.basedOnWorkout = routine
        do {
            try realm.commitWrite()
        } catch let err as NSError {
            print(err)
        }
    }

    /// Finish the running workout and mark it as active = false
    public func finishWorkout() -> Void {
        try! realm.write {
            self.workout.endedAt = NSDate()
            self.workout.active = false
        }
    }

    public func cancelWorkout() -> Void {
        try! realm.write {
            self.realm.delete(self.workout)
        }
    }

    public func performedExercises() -> List<PerformanceExerciseMap> {
        return workout.performedExercises
    }

    public func numberOfPerformedExercises() -> Int {
        return workout.performedExercises.count
    }

    public func exerciseAtIndex(atIndex: Int) -> Exercise {
        return workout.performedExercises[atIndex].exercise
    }

    public func removeExerciseAtIndex(atIndex: Int) -> Void {
        realm.beginWrite()
        workout.performedExercises.removeAtIndex(atIndex)
        try! realm.commitWrite()
    }

    public func performanceAtIndex(atIndex: Int) -> PerformanceExerciseMap {
        return workout.performedExercises[atIndex]
    }

    /// Calculates the values that are later used to calculate
    /// the summary values
    public func calculateWorkoutValues() -> Void {
        realm.beginWrite()
        var totalTime = Double()
        let totalDistance = Double()
        var totalReps = 0
        var totalWeight = Double()
        for performed in self.workout.performedExercises {
            for sets in performed.detailPerformance {
                if sets.time == 0 {
                    totalReps += sets.reps
                    totalWeight += totalWeight
                } else {
                    totalTime += sets.time
                }
            }
        }

        self.workout.totalDistance = totalDistance
        self.workout.totalReps = totalReps
        self.workout.totalWeight = totalWeight
        self.workout.totalRunningTime = totalTime
        try! realm.commitWrite()
    }

    public func setFreeFormName() -> Void {
        try! realm.write {
            self.workout.name = NSLocalizedString("Free Workout", comment: "Free wrkout as a cell title in a new workoutcontroller")
        }
    }

    public func swapExercises(from: Int, to: Int) -> Void {
        try! realm.write {
            self.workout.performedExercises.swap(from, to)
        }
    }

    ///
    private func persist() -> Void {
        realm.beginWrite()
        realm.add(workout)
        try! realm.commitWrite()
    }
}
