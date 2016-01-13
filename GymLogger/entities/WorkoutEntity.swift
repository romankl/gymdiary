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
        return [NSSortDescriptor(key: Keys.startedAt.rawValue, ascending: false)]
    }

    func numberOfPerformedExercises() -> Int? {
        return performedExercises?.array.count
    }

    func finishWorkout() -> Void {
        endedAt = NSDate()
        let interval = endedAt!.timeIntervalSinceDate(startedAt!)
        duration = interval

        isActive = false

        calculateWorkout()
    }

    func calculateWorkout() -> Void {
        guard let performed = performedExercises else {
            return
        }

        var sets = 0
        var reps = 0
        var distance = 0.0
        var time = 0.0
        var weight = 0.0
        for p: PerformanceExerciseMapEntity in performed.array as! [PerformanceExerciseMapEntity] {
            sets += p.completedSets!.integerValue

            if let performance = p.performance {
                for sets: PerformanceEntity in performance.array as! [PerformanceEntity] {
                    reps += sets.reps!.integerValue
                    distance += sets.distance!.doubleValue
                    time += sets.time!.doubleValue
                    weight += sets.weight!.doubleValue
                }
            }
        }

        totalDistance = distance
        totalReps = reps
        totalRunningTime = time
        totalSets = sets
        totalWeight = weight
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
        let exercisesFromRoutine = exercises.array as! [WorkoutRoutineExerciseMapEntity]

        // iterate over all planned exercises
        // take the planned exercise and write it over to the performance table
        // use the planned set var to create n- matching records
        // mark the performance as non-complete
        // take the planned order
        for e: WorkoutRoutineExerciseMapEntity in exercisesFromRoutine {
            let performanceMapping = PerformanceExerciseMapEntity.prepareMapping(e.exercise!,
                    workout: self,
                    context: context)

            performanceMapping.buildUp(e,
                    defaultSets: plannedSets,
                    plannedReps: plannedReps,
                    context: context)

            performanceExerciseMap.append(performanceMapping)
        }

        performedExercises = NSOrderedSet(array: performanceExerciseMap)

        // set the origin of this workout and the destination to keep track of it
        guard let baseRoutineForWorkouts = routine.baseRoutineForWorkout else {
            return
        }

        // add the back reference
        let workouts = baseRoutineForWorkouts.mutableCopy()
        workouts.addObject(self)
        routine.baseRoutineForWorkout = workouts as? NSOrderedSet
    }

    private static let freeWorkoutTitle = NSLocalizedString("Free Workout", comment: "Free workout as a cell title in a new workoutcontroller")
    static func prepareForFreeWorkoutUsage(context: NSManagedObjectContext) -> WorkoutEntity {
        let workout = NSEntityDescription.insertNewObjectForEntityForName(WorkoutEntity.workoutEntityName,
                inManagedObjectContext: context) as! WorkoutEntity
        workout.name = freeWorkoutTitle
        workout.startedAt = NSDate()

        return workout
    }

    private func currentExerciseMap() -> [PerformanceExerciseMapEntity] {
        return performedExercises?.mutableCopy().allObjects as! [PerformanceExerciseMapEntity]
    }

    func performanceAtIndex(index: Int) -> PerformanceExerciseMapEntity {
        let map = currentExerciseMap()
        let elem = map[index]
        return elem
    }

    func exerciseAtIndex(index: Int) -> ExerciseEntity {
        let elem = performanceAtIndex(index)
        return elem.exercise!
    }

    func removeExerciseAtIndex(index: Int) -> Void {
        var map = currentExerciseMap()
        map.removeAtIndex(index)
        performedExercises = NSOrderedSet(array: map)
    }

    func addExercise(exercise: ExerciseEntity, context: NSManagedObjectContext) {
        let performance = PerformanceExerciseMapEntity.prepareMapping(exercise,
                workout: self,
                context: context)

        var map = currentExerciseMap()
        map.append(performance)

        performedExercises = NSOrderedSet(array: map)
    }

    func swapExercises(from: Int, to: Int) {
        var map = currentExerciseMap()
        swap(&map[from], &map[to])
        performedExercises = NSOrderedSet(array: map)
    }
}
