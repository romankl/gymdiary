//
//  ExerciseType.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

/// Used to map the Ui text to realm db objects

public enum ExerciseType: Int, CustomStringConvertible {
    case BodyWeight = 0, Distance, OlympicBarbell, Dumbbell, Machine, Kettlebell, CountedExercise

    static func allTypes() -> [ExerciseType] {
        return [ExerciseType.BodyWeight,
                ExerciseType.OlympicBarbell,
                ExerciseType.Dumbbell,
                ExerciseType.Distance,
                ExerciseType.Kettlebell,
                ExerciseType.CountedExercise]
    }

    public var description: String {
        switch self {
        case .Distance: return NSLocalizedString("Distance", comment: "Distance training")
        case .BodyWeight: return NSLocalizedString("Body Weight", comment: "Bodyweight trainig + extra " +
                "weight")
        case .OlympicBarbell: return NSLocalizedString("Olympic Barbell", comment: "Barbell trainig - extra weight!")
        case .Dumbbell: return NSLocalizedString("Dumbbell", comment: "Dumbbel trainig - no extra weight")
        case .Machine: return NSLocalizedString("Machine", comment: "Machine trainig - no extra weight")
        case .Kettlebell: return NSLocalizedString("Kettlebell", comment: "Kettlebell exercise training type")
        case .CountedExercise: return NSLocalizedString("Counted Exercise", comment: "Counted exercise type")
        }
    }
}
