//
//  ExerciseChooserForRoutine.swift
//  GymLogger
//
//  Created by Roman Klauke on 26.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

struct ExerciseChooserForRoutine {
    var workoutRoutine: WorkoutRoutine
    var completion: (() -> Void)

    init(routine: WorkoutRoutine, cb: (() -> Void)) {
        workoutRoutine = routine
        completion = cb
    }
}