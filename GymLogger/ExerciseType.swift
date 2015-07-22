//
//  ExerciseType.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

/// Used to map the Ui text to realm db objects
enum ExerciseType: Int, Printable {
    case Distance = 1
    case Weight = 0

    var description : String {
        switch self {
        case .Distance: return NSLocalizedString("Distance", comment: "Distance training")
        case .Weight: return NSLocalizedString("Weight", comment: "Weight trainig")
        }
    }
}
