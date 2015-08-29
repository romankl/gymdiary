//
//  SetsRepsValueChange.swift
//  GymLogger
//
//  Created by Roman Klauke on 27.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

protocol SetsRepsValueChange {
    func valueDidChangeTo(newValue: String, atIndex: Int, origin: TrackingInputField)
    func valueIsChangingTo(newValue: String, atIndex: Int, origin: TrackingInputField)
}
