//
//  PerformanceEntity+CoreDataProperties.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PerformanceEntity {

    @NSManaged var distance: NSNumber?
    @NSManaged var preReps: NSNumber?
    @NSManaged var preWeight: NSNumber?
    @NSManaged var reps: NSNumber?
    @NSManaged var time: NSNumber?
    @NSManaged var weight: NSNumber?
    @NSManaged var order: NSNumber?
    @NSManaged var usedForPerformance: PerformanceExerciseMapEntity?

}
