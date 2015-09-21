//
//  Units.swift
//  GymLogger
//
//  Created by Roman Klauke on 04.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

enum WeightUnit: Int, CustomStringConvertible {
    case Lb = 0, Kg
    var description : String {
        switch self {
        case .Lb: return NSLocalizedString("lb", comment: "Weight unit")
        case .Kg: return NSLocalizedString("kg", comment: "Weight unit")
        }
    }
}

enum DistanceUnit: Int, CustomStringConvertible {
    case Kilometres = 0, Miles
    var description : String {
        switch self {
        case .Kilometres: return NSLocalizedString("km", comment: "Kilometres as a unit")
        case .Miles: return NSLocalizedString("mile", comment: "Unit")
        }
    }
}
