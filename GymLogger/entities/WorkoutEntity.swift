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

    static func prepareWorkout(startedAt: NSDate,
                               fromRoutine routine: WorkoutRoutineEntity?,
                               inContext context: NSManagedObjectContext) -> WorkoutEntity {

        let workout = NSEntityDescription.insertNewObjectForEntityForName(WorkoutEntity.workoutEntityName,
                inManagedObjectContext: context) as! WorkoutEntity

        if let routineTemplate = routine {
            workout.name = routineTemplate.name
        }

        workout.basedOnWorkout = routine
        workout.isActive = true
        workout.startedAt = startedAt

        return workout
    }

    static func sortDescriptorForHistory() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: Keys.startedAt.rawValue, ascending: true)]
    }

    func numberOfPerformedExercises() -> Int? {
        return performedExercises?.allObjects.count
    }

    func finishWorkout() -> Void {
        isActive = false
        endedAt = NSDate()
    }

    func buildUp(plannedSets: Int = 0,
                 plannedReps: Int = 0) -> Void {
        guard let routine = basedOnWorkout,
        let exercises = routine.usingExercises,
        let context = managedObjectContext else {
            return
        }

        // this array holds the mapped exercises
        var performanceExerciseMap = [PerformanceExerciseMapEntity]()
        let exercisesFromRoutine = exercises.allObjects as! [WorkoutRoutineExerciseMapEntity]

        // iterate over all planned exercises
        // take the planned exercise and write it over to the performance table
        // use the planned set var to create n- matching records
        // mark the performance as non-complete
        // take the planned order
        for e: WorkoutRoutineExerciseMapEntity in exercisesFromRoutine {
            let performanceMapping = PerformanceExerciseMapEntity.prepareMapping(Int(e.order!),
                    exercise: e.exercise!,
                    workout: self,
                    context: context)

            performanceMapping.buildUp(e,
                    defaultSets: plannedSets,
                    plannedReps: plannedReps,
                    context: context)

            performanceExerciseMap.append(performanceMapping)
        }

        performedExercises = NSSet(array: performanceExerciseMap)

        // set the origin of this workout and the destination to keep track of it
        guard let baseRoutineForWorkouts = routine.baseRoutineForWorkout else {
            return
        }

        // add the back reference
        let workouts = baseRoutineForWorkouts.mutableCopy()
        workouts.addObject(self)
        routine.baseRoutineForWorkout = workouts as? NSSet
    }

    private static let freeWorkoutTitle = NSLocalizedString("Free Workout", comment: "Free workout as a cell title in a new workoutcontroller")
    static func prepareForFreeWorkoutUsage(context: NSManagedObjectContext) -> WorkoutEntity {
        let workout = NSEntityDescription.insertNewObjectForEntityForName(WorkoutEntity.workoutEntityName,
                inManagedObjectContext: context) as! WorkoutEntity
        workout.name = freeWorkoutTitle

        return workout
    }

    private func currentExerciseMap() -> [PerformanceExerciseMap] {
        return performedExercises?.mutableCopy().allObjects as! [PerformanceExerciseMap]
    }

    func exerciseAtIndex(index: Int) -> Exercise {
        let map = currentExerciseMap()
        let elem = map[index]
        return elem.exercise
    }

    func removeExerciseAtIndex(index: Int) -> Void {
        var map = currentExerciseMap()
        map.removeAtIndex(index)
        performedExercises = NSSet(array: map)
    }

    func swapExercises(from: Int, to: Int) {
        var map = currentExerciseMap()
        swap(&map[from], &map[to])
        performedExercises = NSSet(array: map)
    }
}
