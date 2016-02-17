//
//  BarbellTypes.swift
//  GymLogger
//
//  Created by Roman Klauke on 10.02.16.
//  Copyright © 2016 Roman Klauke. All rights reserved.
//

import Foundation


enum BarbellTypes: Int, CustomStringConvertible {
    case Olympic = 0, Ez, Triceps, Shrug

    var description: String {
        switch self {
        case .Olympic: return NSLocalizedString("Olympic Barbell", comment: "Barbell Type")
        case .Ez: return NSLocalizedString("EZ Curl Bar", comment: "EZ Bar")
        case .Triceps: return NSLocalizedString("Triceps Bar", comment: "Triceps Bar")
        case .Shrug: return NSLocalizedString("Shrug/ Trap Bar", comment: "Shrug Bar")
        }
    }
}
