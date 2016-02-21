//
// Created by Roman Klauke on 21.02.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//

import Foundation


enum ExerciseFilterSection: Int {
    case All = 0, BodyPart, Equipment

    static func numberOfSections() -> Int {
        return 3
    }

    func description() -> String {
        switch self {
        case .All: return NSLocalizedString("All Exercises", comment: "Al exercises for filtering")
        case .BodyPart: return NSLocalizedString("By Bodypart", comment: "By bodypart caption for filtering")
        case .Equipment: return NSLocalizedString("By Eqipment", comment: "By equipment caption for filtering")
        }
    }
}
