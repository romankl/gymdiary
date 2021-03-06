//
//  PerformanceExerciseMapEntity.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import Foundation
import CoreData


class PerformanceExerciseMapEntity: NSManagedObject {

    static let entityName = "PerformanceExerciseMapEntity"

    static func prepareMapping(exercise: ExerciseEntity,
                               workout: WorkoutEntity,
                               context: NSManagedObjectContext) -> PerformanceExerciseMapEntity {
        let mapEntity = NSEntityDescription.insertNewObjectForEntityForName(PerformanceExerciseMapEntity.entityName,
                inManagedObjectContext: context) as! PerformanceExerciseMapEntity
        mapEntity.workout = workout
        mapEntity.exercise = exercise

        return mapEntity
    }

    func buildUp(e: WorkoutRoutineExerciseMapEntity,
                 defaultSets: Int,
                 plannedReps: Int,
                 context: NSManagedObjectContext) {
        // A special case: Distance exercise have only one "Set"
        var iterations = 0
        if e.exercise!.type == ExerciseType.Distance.rawValue {
            iterations = 1
        } else {
            iterations = defaultSets
        }

        // generate a new record for each planned set and map it back to the performance map
        var performanceForExercise = [PerformanceEntity]()
        for _ in 0 ..< iterations {
            let performance = PerformanceEntity.preparePerformance(plannedReps,
                    inContext: context)
            performanceForExercise.append(performance)
        }

        performance = NSOrderedSet(array: performanceForExercise)
    }

    func performanceCount() -> Int {
        return (performance?.array.count)!
    }

    /// Check if this performance is complete
    ///
    /// :returns: true if it's a completed performance
    func maybeMarkAsComplete() -> Bool {
        guard let allSets = completedSets,
        let performed = performance else {
            return false
        }

        var completed = false
        if allSets.integerValue == performed.array.count {
            completed = true
            isComplete = completed
        }

        return completed
    }

    func detailPerformance(index: Int) -> PerformanceEntity {
        return (performance?.objectAtIndex(index) as? PerformanceEntity)!
    }

    func move(from from: Int, to: Int) -> Void {
        var map = performance?.array as! [PerformanceEntity]
        swap(&map[from], &map[to])
        performance = NSOrderedSet(array: map)
    }

    func appendNewPerformance(performance: PerformanceEntity) {
        var map = self.performance?.array as! [PerformanceEntity]
        map.append(performance)
        self.performance = NSOrderedSet(array: map)
    }
}
