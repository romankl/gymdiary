//
//  ExerciseToWorkoutChooser.swift
//  GymLogger
//
//  Created by Roman Klauke on 03.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

struct ExerciseToWorkoutChooser {
    var runningWorkout: Workout
    var completion: (() -> Void)

    init(workout: Workout, cb: (() -> Void)) {
        completion = cb
        runningWorkout = workout
    }
}
