//
// Created by Roman Klauke on 22.12.15.
// Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

enum DetailWorkoutSections: Int {
    case BaseInformations = 0, Exercises, Notes, Actions


    init(currentSection: Int) {
        switch currentSection {
        case 0: self = .BaseInformations
        case 1: self = .Exercises
        case 2: self = .Notes
        case 3: self = .Actions
        default:
            self = .BaseInformations // just to get rid of the warning
        }
    }

    func numberOfRowsInSection() -> Int {
        switch self {
        case .BaseInformations, .Notes: return 1
        case .Actions: return 2
        default: return -1
        }
    }

    func canEditRows() -> Bool {
        switch self {
        case .BaseInformations, .Notes, .Actions: return false
        case .Exercises: return true
        }
    }

    func canMoveRows() -> Bool {
        switch self {
        case .Exercises: return true
        default: return false
        }
    }

    static func numberOfSections() -> Int {
        return 4
    }
}
