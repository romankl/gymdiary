//
//  WorkoutEntity+CoreDataProperties.swift
//  GymLogger
//
//  Created by Roman Klauke on 31.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WorkoutEntity {

    @NSManaged var bodyWeight: NSNumber?
    @NSManaged var comment: String?
    @NSManaged var duration: NSNumber?
    @NSManaged var endedAt: NSDate?
    @NSManaged var isActive: NSNumber?
    @NSManaged var name: String?
    @NSManaged var orderPosition: NSNumber?
    @NSManaged var performedInWeekOfYear: NSNumber?
    @NSManaged var performedInYear: NSNumber?
    @NSManaged var progressPicture: String?
    @NSManaged var startedAt: NSDate?
    @NSManaged var totalDistance: NSNumber?
    @NSManaged var totalReps: NSNumber?
    @NSManaged var totalRunningTime: NSNumber?
    @NSManaged var totalWeight: NSNumber?
    @NSManaged var totalSets: NSNumber?
    @NSManaged var basedOnWorkout: WorkoutRoutineEntity?
    @NSManaged var performedExercises: NSOrderedSet?

}
