//
//  ProgressShotEntity.swift
//  GymLogger
//
//  Created by Roman Klauke on 01.01.16.
//  Copyright © 2016 Roman Klauke. All rights reserved.
//

import Foundation
import CoreData


class ProgressShotEntity: NSManagedObject {

    static let entityName = "ProgressShotEntity"

    static func prepareNewShot(filePath: String,
                               context: NSManagedObjectContext) -> ProgressShotEntity {
        let obj = NSEntityDescription.insertNewObjectForEntityForName(ProgressShotEntity.entityName,
                inManagedObjectContext: context) as! ProgressShotEntity
        obj.path = filePath

        return obj
    }

}
