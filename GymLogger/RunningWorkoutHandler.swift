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
    private var workout: Workout!
    private var realm: Realm!

    public init(workout: Workout, realm: Realm = Realm()) {
        self.workout = workout
        self.realm = realm
    }

    /// Builds the workout based on the given `routine` and
    /// the current keyValue settings
    ///
    /// :params: fromRoutine the template routine that should be used as a reference
    public func buildUp(fromRoutine routine: WorkoutRoutine) -> Void {
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
                performance.reps = planedReps
                performanceMap.detailPerformance.append(performance)

                if exercise.type == ExerciseType.Distance.rawValue {
                    break
                }
            }

            performanceMap.exercise = exercise
            workout.performedExercises.append(performanceMap)
        }
        workout.basedOnWorkout = routine
    }

    /// Finish the running workout and mark it as active = false
    public func finishWorkout() -> Void {
        realm.write {
            self.workout.endedAt = NSDate()
            self.workout.active = false
        }
    }

    /// Calculates the values that are later used to calculate
    /// the summary values
    public func calculateWorkoutValues() -> Void {
        realm.beginWrite()
        var totalTime = Double()
        var totalDistance = Double()
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
        realm.commitWrite()
    }

    public func cancelWorkout() -> Void {
        self.realm.beginWrite()
        self.realm.delete(workout)
        self.realm.commitWrite()
    }
}
