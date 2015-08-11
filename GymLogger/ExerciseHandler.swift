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

    public func getWorkoutName() -> String? {
        if let exe = exercise {
            return exe.name
        }
        return nil
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
}
