//
//  RealmModel.swift
//  GymLogger
//
//  Created by Roman Klauke on 21.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import RealmSwift


class Exercise: Object {
    dynamic var name = "" // workout name
    dynamic var type = 0  // workout type (0 = weight, 1 = time/ distance)
    dynamic var builtin = false // is it a built in Exercise
    dynamic var bodyGroup = 0 // TODO: Define!!
    dynamic var comment = "" // comment (optional)
    dynamic var lastUsed: NSDate? = NSDate() // when was this exercise the last time used?
    dynamic var used = 0 // inc each time this one is used
    dynamic var archived = false // built in exercises can be archived
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt: NSDate? = NSDate()

    // Inverse relations
    var performed: [PerformedExercise] {
        return linkingObjects(PerformedExercise.self, forProperty: "exercise")
    }

    var definedInRoutine: [WorkoutRoutine] {
        return linkingObjects(WorkoutRoutine.self, forProperty: "exercises")
    }
}

/// A mapping object that maps the weight/ distance or time to each exercise
class PerformedExercise: Object {
    dynamic var weight = Double()
    dynamic var reps = 0
    dynamic var distance = 0
    dynamic var time =  Double()
    dynamic var exercise: Exercise!
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt: NSDate? = NSDate()
}

/// Performed Workouts
class Workout: Object {
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt: NSDate? = NSDate()
    let performedExercises = List<PerformedExercise>() // "To many" for the
    dynamic var name = "" // name of the workout -> should be the copy of the original workout
    dynamic var startedAt = NSDate() // date when the workout was pe
    dynamic var endedAt = NSDate() // when the workout was ended
    dynamic var comment = "" // optional comment
    dynamic var bodyWeight = Double() // optional bodyweight
    dynamic var basedOnWorkout: WorkoutRoutine? // original workout
}

/// Workout "templates"
class WorkoutRoutine: Object {
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt: NSDate? = NSDate()
    dynamic var name = ""
    dynamic var comment = ""
    let exercises = List<Exercise>()

    
    var performedWorkouts: [Workout] {
        return linkingObjects(Workout.self, forProperty: "basedOnWorkout")
    }
}
