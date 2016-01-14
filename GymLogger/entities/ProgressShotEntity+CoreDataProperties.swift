//
//  ProgressShotEntity+CoreDataProperties.swift
//  GymLogger
//
//  Created by Roman Klauke on 14.01.16.
//  Copyright © 2016 Roman Klauke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ProgressShotEntity {

    @NSManaged var path: String?
    @NSManaged var forWorkout: NSOrderedSet?
    @NSManaged var usedInCollection: ProgressShotCollectionEntity?

}
