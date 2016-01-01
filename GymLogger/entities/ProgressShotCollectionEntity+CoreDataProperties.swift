//
//  ProgressShotCollectionEntity+CoreDataProperties.swift
//  GymLogger
//
//  Created by Roman Klauke on 01.01.16.
//  Copyright © 2016 Roman Klauke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ProgressShotCollectionEntity {

    @NSManaged var name: String?
    @NSManaged var usingShot: NSSet?

}
