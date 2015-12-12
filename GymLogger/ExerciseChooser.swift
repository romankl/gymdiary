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
    var beforeCompletion: ((id:NSUUID) -> Void)
    var withTransaction = false

    init(routine: WorkoutRoutine, cb: (() -> Void), beforeCb: ((id:NSUUID) -> Void), transaction: Bool = false) {
        workoutRoutine = routine
        completion = cb
        beforeCompletion = beforeCb
        withTransaction = transaction
    }
}
