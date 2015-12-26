//
//  ExerciseEntity.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import Foundation
import CoreData


class ExerciseEntity: BaseEntity {

    static let entityName = "ExerciseEntity"

    var isInsertObject = false

    enum Keys: String {
        case name
    }

    static func preprareNewExercise(context: NSManagedObjectContext) -> ExerciseEntity {
        let exercise = NSEntityDescription.insertNewObjectForEntityForName(ExerciseEntity.entityName,
                inManagedObjectContext: context) as! ExerciseEntity
        return exercise
    }

    static func sortDescriptorsForOverview() -> [NSSortDescriptor] {
        let sortDescriptor = NSSortDescriptor(key: Keys.name.rawValue, ascending: true, selector: "localizedCompare:")
        return [sortDescriptor]
    }

    static func predicateForOverview() -> NSPredicate {
        let predicate = NSPredicate(format: "%K == false", Keys.name.rawValue)
        return predicate
    }

    func isNameUnique(name: String, usingContext context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: ExerciseEntity.entityName)
        fetchRequest.predicate = NSPredicate(format: "%K LIKE [cd] %@", Keys.name.rawValue, name)

        do {
            let result = try context.executeFetchRequest(fetchRequest)
            return result.count == 0
        } catch {
            print("err while fetching unique names \(error)")
            return false
        }
    }
}
