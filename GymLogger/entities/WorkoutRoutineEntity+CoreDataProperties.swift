//
//  WorkoutRoutineEntity+CoreDataProperties.swift
//  GymLogger
//
//  Created by Roman Klauke on 30.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WorkoutRoutineEntity {

    @NSManaged var color: String?
    @NSManaged var comment: String?
    @NSManaged var isArchived: NSNumber?
    @NSManaged var isReminderActive: NSNumber?
    @NSManaged var lastTimeUsed: NSDate?
    @NSManaged var name: String?
    @NSManaged var remindAt: NSDate?
    @NSManaged var used: NSNumber?
    @NSManaged var baseRoutineForWorkout: NSOrderedSet?
    @NSManaged var usingExercises: NSOrderedSet?

}
