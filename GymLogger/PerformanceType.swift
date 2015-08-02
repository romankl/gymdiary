//
//  PerformanceType.swift
//  GymLogger
//
//  Created by Roman Klauke on 02.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

/// Temp. used in the Perfomance object to map the required fields to a matching input.
/// Later, it should be possible to use the informations of th used exercise to query the right columns
enum PerformanceType: Int {
    case Running = 0, Weight
}
