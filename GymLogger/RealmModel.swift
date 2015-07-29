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
    dynamic var lastUsed = NSDate() // when was this exercise the last time
    dynamic var used = 0 // inc each time this one is used
    dynamic var archived = false // built in exercises can be archived
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt = NSDate()

    override class func primaryKey() -> String {
        return "name"
    }

    // Inverse relations
    var performed: [PerformanceExerciseMap] {
        return linkingObjects(PerformanceExerciseMap.self, forProperty: "exercise")
    }

    var definedInRoutine: [WorkoutRoutine] {
        return linkingObjects(WorkoutRoutine.self, forProperty: "exercises")
    }

    override static func indexedProperties() -> [String] {
        return ["type", "bodyGroup"]
    }
}

/// A mapping object that maps the weight/ distance or time to each exercise
class PerformanceExerciseMap: Object {
    dynamic var exercise: Exercise!
    let detailPerformance = List<Perfomance>()
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt = NSDate()
}

class Perfomance: Object {
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt = NSDate()
    dynamic var weight = Double()
    dynamic var reps = 0
    dynamic var distance = Double()
    dynamic var time =  Double()
    dynamic var type = 0
}

/// Performed Workouts
class Workout: Object {
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt = NSDate()
    let performedExercises = List<PerformanceExerciseMap>() // "To many" for the
    dynamic var name = "" // name of the workout -> should be the copy of the original workout
    dynamic var startedAt = NSDate() // date when the workout was pe
    dynamic var endedAt = NSDate() // when the workout was ended
    dynamic var active = true // is the workout still running?
    dynamic var comment = "" // optional comment
    dynamic var bodyWeight = Double() // optional bodyweight
    dynamic var basedOnWorkout: WorkoutRoutine? // original workout / optional in case that its a freeform workout
    dynamic var totalReps = 0
    dynamic var totalWeight = Double()
    dynamic var totalDistance = Double()
    dynamic var totalRunningTime = Double() // Defines the total time of all running exercises - not the total time of the workout
}

/// Workout "templates"
class WorkoutRoutine: Object {
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt = NSDate()
    dynamic var name = ""
    dynamic var comment = ""
    let exercises = List<Exercise>()

    dynamic var nextReminder = NSDate()
    dynamic var reminderActive = false

    override class func primaryKey() -> String {
        return "name"
    }
    
    var performedWorkouts: [Workout] {
        return linkingObjects(Workout.self, forProperty: "basedOnWorkout")
    }
}
