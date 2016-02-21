//
//  BodyParts.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

/// BodyParts is used as a bridge between the db objects and the Ui.
/// Èxercise` objects require the body group of the exercise and this enum
/// bridges between the db and ui layer.

public enum BodyParts: Int, CustomStringConvertible {
    case Abs = 0
    case Arms
    case Back
    case Chest
    case Legs
    case Shoulder


    static func allBodyParts() -> [BodyParts] {
        return [BodyParts.Abs,
                BodyParts.Arms,
                BodyParts.Back,
                BodyParts.Chest,
                BodyParts.Legs,
                BodyParts.Shoulder]
    }

    public var description: String {
        switch self {
        case .Chest: return NSLocalizedString("Chest", comment: "Chest as Body Part")
        case .Legs: return NSLocalizedString("Legs", comment: "Legs as Body Part")
        case .Arms: return NSLocalizedString("Arms", comment: "Arms as Body Part")
        case .Back: return NSLocalizedString("Back", comment: "Back as Body Part")
        case .Shoulder: return NSLocalizedString("Shoulder", comment: "Shoulder as Body Part")
        case .Abs: return NSLocalizedString("Abs", comment: "Abs as Body Part")
        }
    }
}
