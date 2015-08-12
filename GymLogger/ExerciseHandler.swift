//
//  ExerciseHandler.swift
//  GymLogger
//
//  Created by Roman Klauke on 11.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import RealmSwift

public class ExerciseHandler: PersistenceHandlerProtocol {
    private var realm: Realm!
    private var exercise: Exercise?

    public init(realmToUse realm: Realm = Realm()) {
        self.realm = realm
    }

    public init(realmToUse realm: Realm = Realm(), exerciseName name: String) {
        self.realm = realm
        loadExistingExercise(exerciseName: name)
    }

    public func createBasicExercise() -> Void {
        exercise = Exercise()
    }

    /// Creates a new exercise and saves it directly into the db
    ///
    /// :params: Name of the exercise - must be unique!
    /// :params: bodyPart which part of the body this exercise will use
    /// :type: exercise type
    public func createNewExercise(name: String, bodyPart: BodyParts, type: ExerciseType) -> Void {
        realm.beginWrite()
        exercise = Exercise()
        exercise!.name = name
        exercise!.type = type.rawValue
        exercise!.bodyGroup = bodyPart.rawValue
        realm.add(exercise!)
        realm.commitWrite()
    }

    /// Constraint check.
    /// Make sure that the name is unique in the Exercise table
    ///
    /// :params: `name` case-insensitive name of the exercise
    ///
    /// :returns: true if the name is unique
    public func isExerciseNameUnique(name: String) -> Bool {
        let result = realm.objects(Exercise).filter("name ==[c] %@", name)
        return result.count == 0
    }

    /// Loads the named exercise onto the exercise object that this handler manages
    ///
    /// :param: exerciseName unique name of the exercise
    ///
    /// :returns: true if the query returned at least one result
    public func loadExistingExercise(exerciseName name: String) -> Bool {
        let result = realm.objects(Exercise).filter("name ==[c] %@", name)
        if let found = result.first {
            exercise = found
        }

        return result.count > 0
    }

    public func setExerciseType(type: ExerciseType) -> Void {
        realm.beginWrite()
        exercise?.type = type.rawValue
        realm.commitWrite()
    }

    public func setBodyPart(part: BodyParts) -> Void {
        realm.beginWrite()
        exercise?.bodyGroup = part.rawValue
        realm.commitWrite()
    }

    public func getBodyPart() -> BodyParts? {
        if let exe = exercise {
            return BodyParts(rawValue: exercise!.bodyGroup)!
        }
        return nil
    }

    public func getExerciseType() -> ExerciseType? {
        if let exe = exercise {
            return ExerciseType(rawValue: exercise!.type)
        }
        return nil
    }

    public func getName() -> String? {
        return exercise?.name
    }

    public func createNewObject() -> Void {
        realm.beginWrite()
        realm.add(exercise!)
        realm.commitWrite()
    }

    public func updateObject() -> Void {
        realm.beginWrite()
        realm.add(exercise!, update: true)
        realm.commitWrite()
    }

    /// Deletes the exercise from the db
    public func deleteObject() -> Void {
        if let exe = exercise {
            realm.beginWrite()
            realm.delete(exe)
            realm.commitWrite()
        }
    }

    /// Set a new comment for this exercise
    ///
    /// :params: new comment
    public func setComment(comment: String) -> Void {
        if let exe = exercise {
            exe.comment = comment
        }
    }

    /// Returns the comment of this exercise
    ///
    /// :returns: comment
    public func getComment() -> String? {
        return exercise?.comment
    }

    /// Sets the name of the exercise
    ///
    /// :params: name of the exercise - must be unique!
    public func setName(name: String) -> Void {
        if let exe = exercise {
            realm.beginWrite()
            exe.name = name
            realm.commitWrite()
        }
    }

    /// Get the raw db exercise object 
    ///
    /// :returns: the current exercise
    public func getRawExercise() -> Exercise? {
        return exercise
    }
}
