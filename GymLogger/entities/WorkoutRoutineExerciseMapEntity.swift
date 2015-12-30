//
//  WorkoutRoutineExerciseMapEntity.swift
//  GymLogger
//
//  Created by Roman Klauke on 30.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import Foundation
import CoreData


class WorkoutRoutineExerciseMapEntity: BaseEntity {

    static let entityName = "WorkoutRoutineExerciseMapEntity"

    static func prepareMapping(exercise: ExerciseEntity,
        routine: WorkoutRoutineEntity,
        context: NSManagedObjectContext) -> WorkoutRoutineExerciseMapEntity {
            let entity = NSEntityDescription.insertNewObjectForEntityForName(WorkoutRoutineExerciseMapEntity.entityName,
                inManagedObjectContext: context) as! WorkoutRoutineExerciseMapEntity

            entity.exercise = exercise
            entity.routine = routine
            return entity
    }
}
