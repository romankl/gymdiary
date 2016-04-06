//
//  Units.swift
//  GymLogger
//
//  Created by Roman Klauke on 04.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

enum WeightUnit: Int, CustomStringConvertible {
    case Kg = 0, Lb
    var description: String {
        switch self {
        case .Lb: return NSLocalizedString("lb", comment: "Weight unit")
        case .Kg: return NSLocalizedString("kg", comment: "Weight unit")
        }
    }


    func availablePlates() -> [Float] {
        switch self {
        case .Lb: return [55, 45, 35, 25] // TODO: Check the other plates (non-iwf)
        case .Kg: return [25, 20, 15, 10, 5, 2.5, 2, 1.5, 1.25, 1, 0.5]
        }
    }
}

enum DistanceUnit: Int, CustomStringConvertible {
    case Kilometres = 0, Miles
    var description: String {
        switch self {
        case .Kilometres: return NSLocalizedString("km", comment: "Kilometres as a unit")
        case .Miles: return NSLocalizedString("mile", comment: "Unit")
        }
    }
}
