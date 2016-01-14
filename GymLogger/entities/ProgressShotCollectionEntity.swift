//
//  ProgressShotCollectionEntity.swift
//  GymLogger
//
//  Created by Roman Klauke on 01.01.16.
//  Copyright © 2016 Roman Klauke. All rights reserved.
//

import Foundation
import CoreData


class ProgressShotCollectionEntity: NSManagedObject {

    static let entityName = "ProgressShotCollectionEntity"

    static func prepareNewCollection(name: String,
                                     context: NSManagedObjectContext) -> ProgressShotCollectionEntity {
        let obj = NSEntityDescription.insertNewObjectForEntityForName(ProgressShotCollectionEntity.entityName,
                inManagedObjectContext: context) as! ProgressShotCollectionEntity
        obj.name = name

        return obj
    }

    func addProgressShot(progress: ProgressShotEntity) {
        var existingShots = usingShot!.array as! [ProgressShotEntity]
        existingShots.append(progress)

        usingShot = NSOrderedSet(array: existingShots)
    }

    func progressAtIndex(index: Int) -> ProgressShotEntity {
        let existingShots = usingShot!.array as! [ProgressShotEntity]
        return existingShots[index]
    }

    func removeProgressAtIndex(index: Int) {
        var existingShots = usingShot!.array as! [ProgressShotEntity]
        existingShots.removeAtIndex(index)

        usingShot = NSOrderedSet(array: existingShots)
    }

    func move(from: Int, to: Int) {
        var existingShots = usingShot!.array as! [ProgressShotEntity]
        swap(&existingShots[from], &existingShots[to])

        usingShot = NSOrderedSet(array: existingShots)
    }
}
