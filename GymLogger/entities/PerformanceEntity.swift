//
//  PerformanceEntity.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import Foundation
import CoreData


class PerformanceEntity: NSManagedObject {

    static let entityName = "PerformanceEntity"

    static func preparePerformance(reps: Int,
                                   inContext context: NSManagedObjectContext) -> PerformanceEntity {
        let entity = NSEntityDescription.insertNewObjectForEntityForName(entityName,
                inManagedObjectContext: context) as! PerformanceEntity
        entity.reps = reps

        return entity
    }
}
