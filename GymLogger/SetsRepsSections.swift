//
//  SetsRepsSections.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import Foundation

enum SetsRepsSections: Int {
    case Meta = 0, RepsSets, Notes

    init(section: Int) {
        switch section {
        case 0 : self = .Meta
        case 1: self = .RepsSets
        case 2: self = .Notes
        default: self = .RepsSets
        }
    }

    func canEditRows() -> Bool {
        switch self {
        case .Notes, .Meta: return false
        case .RepsSets: return true
        }
    }

    static func totalSections() -> Int {
        return 2
    }
}
