//
//  BaseEntity+CoreDataProperties.swift
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

extension BaseEntity {

    @NSManaged var createdAt: NSDate?
    @NSManaged var updatedAt: NSDate?

}