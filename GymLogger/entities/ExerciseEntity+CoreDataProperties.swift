//
//  ExerciseEntity+CoreDataProperties.swift
//  GymLogger
//
//  Created by Roman Klauke on 13.02.16.
//  Copyright © 2016 Roman Klauke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ExerciseEntity {

    @NSManaged var bodyGroup: NSNumber?
    @NSManaged var comment: String?
    @NSManaged var isArchived: NSNumber?
    @NSManaged var isBuiltIn: NSNumber?
    @NSManaged var lastTimeUsed: NSDate?
    @NSManaged var name: String?
    @NSManaged var type: NSNumber?
    @NSManaged var used: NSNumber?
    @NSManaged var groupingName: String?
    @NSManaged var performedInWorkout: NSOrderedSet?
    @NSManaged var plannedForWorkoutRoutine: NSOrderedSet?

}
