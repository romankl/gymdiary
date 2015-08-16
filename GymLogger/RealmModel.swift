//
//  RealmModel.swift
//  GymLogger
//
//  Created by Roman Klauke on 21.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import RealmSwift


public class Exercise: Object {
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt = NSDate()

    dynamic var name = "" // workout name
    dynamic var type = 0  // workout type (0 = weight, 1 = time/ distance)
    dynamic var builtin = false // is it a built in Exercise
    dynamic var bodyGroup = 0 // TODO: Define!!
    dynamic var comment = "" // comment (optional)
    dynamic var lastUsed = NSDate() // when was this exercise the last time
    dynamic var used = 0 // inc each time this one is used
    dynamic var archived = false // built in exercises can be archived

    dynamic var volatileId = ""
    override public static func ignoredProperties() -> [String] {
        return ["volatileId"]
    }

    override public class func primaryKey() -> String {
        return "name"
    }

    // Inverse relations
    var performed: [PerformanceExerciseMap] {
        return linkingObjects(PerformanceExerciseMap.self, forProperty: "exercise")
    }

    var definedInRoutine: [WorkoutRoutine] {
        return linkingObjects(WorkoutRoutine.self, forProperty: "exercises")
    }

    override public static func indexedProperties() -> [String] {
        return ["type", "bodyGroup", "archived"]
    }
}

/// A mapping object that maps the weight/ distance or time to each exercise
public class PerformanceExerciseMap: Object {
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt = NSDate()

    dynamic var exercise: Exercise!

    // used as an identifier for ordered results
    dynamic var volatileId = ""
    // all the performed sets for this exercise are store using the list.
    // An object can be used for weights or distances depending on the used exercise.
    let detailPerformance = List<Performance>()

    override public static func ignoredProperties() -> [String] {
        return ["volatileId"]
    }
}

/// Each set is available as a seperate object
public class Performance: Object {
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt = NSDate()

    dynamic var weight = Double()
    dynamic var reps = 0
    dynamic var distance = Double()
    dynamic var time =  Double()
}

/// Performed Workouts
public class Workout: Object {
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

    dynamic var progressPic = ""

    // grouping property
    var performedInWeekOfYear: Int {
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: startedAt)
        return components.weekOfYear
    }

    var duration: NSTimeInterval {
        return endedAt.timeIntervalSinceDate(startedAt)
    }

    override public static func indexedProperties() -> [String] {
        return ["name", "comment"]
    }
}

/// Workout "templates"
public class WorkoutRoutine: Object {
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt = NSDate()

    dynamic var name = ""
    dynamic var comment = ""
    dynamic var color = "" // Workout "color" code

    let exercises = List<Exercise>()

    dynamic var nextReminder = NSDate()
    dynamic var reminderActive = false

    override public class func primaryKey() -> String {
        return "name"
    }

    override public static func indexedProperties() -> [String] {
        return ["comment", "color"]
    }

    var performedWorkouts: [Workout] {
        return linkingObjects(Workout.self, forProperty: "basedOnWorkout")
    }
}

/// Values that are calculated through the whole model.
/// Stored here to reduce the total calculation time
public class Summary: Object {
    // TODO: Not so sure, if this one could be better solved using a query
    // to avoid doubled data.
    // The idea behind it is, that i could store all the calculated values
    // after the workout on this one object and use them for different statistics
    dynamic var createdAt = NSDate() // when was it created?
    dynamic var updatedAt = NSDate()

    dynamic var totalSets = 0
    dynamic var totalReps = 0
    dynamic var totalDistance = Double()
    dynamic var totalTime = NSDate()
    dynamic var totalWeight = Double()
    dynamic var totalWorkouts = 0
    dynamic var totalUsedExercises = 0
    dynamic var totalAddedExercises = 0
    dynamic var totalTrackedTime = NSDate()
    dynamic var avgWorkoutDuration = NSDate()
    dynamic var avgRepsPerWorkout = 0
    dynamic var avgSetsPerWorkout = 0
    dynamic var avgWeightPerRep = Double()
}
