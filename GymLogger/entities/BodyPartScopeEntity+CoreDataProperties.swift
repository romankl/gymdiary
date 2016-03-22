//
//  BodyPartScopeEntity+CoreDataProperties.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.03.16.
//  Copyright © 2016 Roman Klauke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BodyPartScopeEntity {

    @NSManaged var scope: NSDecimalNumber?
    @NSManaged var bodyPart: NSNumber?
    @NSManaged var measuredAt: NSDate?

}
