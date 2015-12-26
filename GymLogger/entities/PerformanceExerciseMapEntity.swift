//
//  PerformanceExerciseMapEntity.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import Foundation
import CoreData


class PerformanceExerciseMapEntity: BaseEntity {

    static let entityName = "PerformanceExerciseMapEntity"

    static func prepareMapping(order: Int,
                               exercise: ExerciseEntity,
                               workout: WorkoutEntity,
                               context: NSManagedObjectContext) -> PerformanceExerciseMapEntity {
        let mapEntity = NSEntityDescription.insertNewObjectForEntityForName(PerformanceExerciseMapEntity.entityName,
                inManagedObjectContext: context) as! PerformanceExerciseMapEntity
        mapEntity.order = order
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
        if e.exercise!.type != ExerciseType.Distance.rawValue {
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

        performance = NSSet(array: performanceForExercise)
    }

    private func attachedPerformance() -> [PerformanceEntity] {
        return performance?.allObjects as! [PerformanceEntity]
    }

    func performanceCount() -> Int {
        return attachedPerformance().count
    }

    func detailPerformance(index: Int) -> PerformanceEntity {
        let map = attachedPerformance()
        return map[index]
    }

    func move(from from: Int, to: Int) -> Void {
        var map = attachedPerformance()
        swap(&map[from], &map[to])
        performance = NSSet(array: map)
    }

    func appendNewPerformance(performance: PerformanceEntity) {
        var map = attachedPerformance()
        map.append(performance)
        self.performance = NSSet(array: map)
    }
}
