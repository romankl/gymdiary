//
//  PersistenceHandlerProtocol.swift
//  GymLogger
//
//  Created by Roman Klauke on 11.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

protocol PersistenceHandlerProtocol {
    /// Creates the Object in the db
    func createNewObject() -> Void

    /// Updates the obj in the db
    func updateObject() -> Void
}