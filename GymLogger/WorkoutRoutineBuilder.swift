//
//  WorkoutRoutineBuilder.swift
//  GymLogger
//
//  Created by Roman Klauke on 10.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import RealmSwift

public class WorkoutRoutineBuilder: PersistenceHandlerProtocol {
    private var realm: Realm!
    private var workoutRoutine: WorkoutRoutine?

    public init(realm: Realm = try! Realm()) {
        self.realm = realm
    }

    /// Initializes the workoutRoutine with the named routine
    ///
    /// :params: routineName name of the routine that should be loaded into the handle
    /// :params: realm defaults to the defaultRealm 
    public init(routineName name: String, realm: Realm = try! Realm()) {
        self.realm = realm
        loadExercise(routineName: name)
    }

    /// Creates a new routine with the given name as the 
    /// routinename 
    ///
    /// :params: routineName name of the routine - the name becomes the primary key!
    public func createNewRoutine(routineName name: String) -> Void {
        workoutRoutine = WorkoutRoutine()
        workoutRoutine!.name = name
    }

    /// Creates a empty routine
    public func createEmptyRoutine() {
        workoutRoutine = WorkoutRoutine()
    }

    /// Returns the count of added exercises for this workout
    public func exercisesInWorkout() -> Int? {
        return workoutRoutine?.exercises.count
    }

    /// Adds the exercise to the routine
    public func addExercise(exercise: Exercise) -> Void {
        if let _ = workoutRoutine {
            realm.beginWrite()
            workoutRoutine?.exercises.append(exercise)
            try! realm.commitWrite()
        }
    }

    /// Adds the exercise to the routine
    public func addExercise(exerciseName name: String) -> Void {
        let result = realm.objects(Exercise).filter("name =[c]%@", name)
        if let exercise = result.first {
            workoutRoutine?.exercises.append(exercise)
        }
    }

    ///
    public func switchExercise(fromPosition: Int, toPosition: Int) -> Void {
        // TODO
    }

    /// Loads the exercise using the given name
    ///
    /// :params: routineName name of the exercise - case insensitive
    public func loadExercise(routineName name: String) -> Bool {
        let result = realm.objects(WorkoutRoutine).filter("name ==[c] %@", name)
        workoutRoutine = result.first
        return result.count > 0
    }

    /// Check the already existing routines and try to match the name
    /// to make sure, that the (new) object will be unique.
    /// The name of a routine is a primary key
    ///
    /// :params: routineName name of the routine - case insensitve
    /// 
    /// - returns: true if it is a unique name
    public func isRoutineNameUnique(routineName name: String) -> Bool {
        return realm.objects(WorkoutRoutine).filter("name ==[c] %@", name).count == 0
    }

    /// Returns the raw workoutroutine that this class handles
    ///
    /// - returns: workoutRoutine thats handled
    public func getRawRoutine() -> WorkoutRoutine? {
        return workoutRoutine
    }

    /// Returns the exercise at the given index
    ///
    /// :params: index index of the exercise
    public func getExerciseAtIndex(index: Int) -> Exercise? {
        if index >= 0 && index <= workoutRoutine?.exercises.count {
            return workoutRoutine?.exercises[index]
        }
        return nil
    }

    /// Returns the name of the workoutRoutine thats currently available
    public func getWorkoutRoutineName() -> String? {
        return workoutRoutine?.name
    }

    /// Sets the name in the workoutRoutine
    /// !!! Warning only allowed if the object
    /// is not available or saved to the realm!!!
    ///
    /// :params: routineName
    public func setWorkoutRoutineName(name: String, transactionRequired: Bool = false) -> Void {
        if (transactionRequired) {
            realm.beginWrite()
        }
        workoutRoutine?.name = name
        if (transactionRequired) {
            try! realm.commitWrite()
        }
    }

    public func getRawExercises() -> List<Exercise>? {
        return workoutRoutine?.exercises
    }

    /// Creates the Object in the db
    public func createNewObject() -> Void {
        if let _ = workoutRoutine {
            realm.beginWrite()
            realm.add(workoutRoutine!)
            try! realm.commitWrite()
        }
    }

    /// Updates the obj in the db
    public func updateObject() -> Void {

    }

    /// Delete operation
    public func deleteObject() -> Void {
        if let _ = workoutRoutine {
            realm.beginWrite()
            realm.delete(workoutRoutine!)
            try! realm.commitWrite()
        }
    }

    /// Deletes the exercise at the given index
    ///
    /// :params: index of the exercise
    public func removeExerciseAtIndex(index: Int, withTransaction: Bool = false) -> Void {
        if index >= 0 && index <= workoutRoutine?.exercises.count {
            if withTransaction {
                realm.beginWrite()
            }
            workoutRoutine?.exercises.removeAtIndex(index)
            if withTransaction {
                try! realm.commitWrite()
            }
        }
    }

    public func swap(from: Int, to: Int) -> Void {
        try! realm.write {
            self.workoutRoutine?.exercises.swap(from, to)
        }
    }
}
