//
//  ExerciseEntity+CoreDataProperties.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ExerciseEntity {

    @NSManaged var bodyGroup: NSNumber?
    @NSManaged var isBuiltIn: NSNumber?
    @NSManaged var comment: String?
    @NSManaged var isArchived: NSNumber?
    @NSManaged var lastUsed: NSDate?
    @NSManaged var name: String?
    @NSManaged var type: NSNumber?
    @NSManaged var used: NSNumber?
    @NSManaged var performedInWorkout: NSSet?
    @NSManaged var usedInWorkoutRoutine: NSSet?

}
