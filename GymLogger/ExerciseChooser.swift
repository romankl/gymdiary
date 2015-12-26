//
//  ExerciseChooserForRoutine.swift
//  GymLogger
//
//  Created by Roman Klauke on 26.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

struct ExerciseChooserForRoutine {
    var workoutRoutine: WorkoutRoutineEntity
    var completion: (() -> Void)
    var beforeCompletion: ((id:NSUUID) -> Void)

    init(routine: WorkoutRoutineEntity, cb: (() -> Void), beforeCb: ((id:NSUUID) -> Void)) {
        workoutRoutine = routine
        completion = cb
        beforeCompletion = beforeCb
    }
}
