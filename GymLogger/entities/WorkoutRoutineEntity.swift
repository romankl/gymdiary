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

    var isInsertObject = false

    enum Keys: String {
        case name
        case isActive
        case isArchived
    }

    static func sortDescriptorForNewWorkout() -> [NSSortDescriptor] {
        let sortDescriptor = NSSortDescriptor(key: Keys.name.rawValue, ascending: true, selector: "localizedCompare:")
        return [sortDescriptor]
    }

    static func predicateForRoutines(archived: Bool = false) -> NSPredicate {
        let predicate = NSPredicate(format: "%K == 0", Keys.isArchived.rawValue, archived)
        return predicate
    }

    static func prepareForNewWorkout(context: NSManagedObjectContext) -> WorkoutRoutineEntity {
        let entity = NSEntityDescription.insertNewObjectForEntityForName(WorkoutRoutineEntity.entityName,
                inManagedObjectContext: context) as! WorkoutRoutineEntity
        entity.isReminderActive = false
        entity.name = String()

        return entity
    }

    func countOfExercises() -> Int {
        guard let exercises = usingExercises else {
            return 0
        }
        return exercises.array.count
    }

    func isNameUnique(routineName name: String) -> Bool {
        guard let context = managedObjectContext else {
            return false
        }

        let fetchRequest = NSFetchRequest(entityName: WorkoutRoutineEntity.entityName)
        fetchRequest.predicate = NSPredicate(format: "%K LIKE [cd] %@", Keys.name.rawValue, name)
        do {
            let result = try context.executeFetchRequest(fetchRequest)
            return result.count == 0
        } catch {
            print("Error while unique check for routine: \(error)")
            return false
        }
    }

    func removeExercise(atIndex index: Int, context: NSManagedObjectContext) {
        if let addedExercises = usingExercises {
            var exercises = addedExercises.array

            let obj = exercises.removeAtIndex(index) as! WorkoutRoutineExerciseMapEntity
            context.deleteObject(obj)
            usingExercises = NSOrderedSet(array: exercises)
        }
    }

    func exerciseAtIndex(index: Int) -> ExerciseEntity? {
        if let addedExercises = usingExercises {
            var exercises = addedExercises.array
            return (exercises[index] as! WorkoutRoutineExerciseMapEntity).exercise
        }

        return nil
    }

    func swapExercises(from: Int, to: Int) {
        guard let exercises = usingExercises else {
            return
        }

        var allExercises = exercises.array
        swap(&allExercises[from], &allExercises[to])

        usingExercises = NSOrderedSet(array: allExercises)
    }

    func appendExercise(exercise: ExerciseEntity, context: NSManagedObjectContext) {
        guard let exercises = usingExercises else {
            return
        }

        let mapping = WorkoutRoutineExerciseMapEntity.prepareMapping(exercise,
                routine: self,
                context: context)

        var allExercises = exercises.array as! [WorkoutRoutineExerciseMapEntity]

        allExercises.append(mapping)

        usingExercises = NSOrderedSet(array: allExercises)
    }
}
