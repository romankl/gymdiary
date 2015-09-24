//
//  RunningWorkoutSegueIdentifiers.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import Foundation

enum RunningWorkoutSegueIdentifier: String {
    case AddExerciseSegue = "addExercise"
    case SetRepsSetsSegue = "setStats"
    case DistanceExericse = "trackDistance"
    case WeightExercise = "trackRepsSets"

    init(identifier: String) {
        switch identifier {
        case "addExercise": self = .AddExerciseSegue
        case "setStats": self = .SetRepsSetsSegue
        case "trackDistance": self = .DistanceExericse
        case "trackRepsSets": self = .WeightExercise
        default:
            self = .AddExerciseSegue
        }
    }
}
