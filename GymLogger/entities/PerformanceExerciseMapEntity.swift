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
