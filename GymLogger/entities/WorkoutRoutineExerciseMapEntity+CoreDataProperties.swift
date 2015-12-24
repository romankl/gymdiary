//
//  WorkoutRoutineExerciseMapEntity+CoreDataProperties.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WorkoutRoutineExerciseMapEntity {

    @NSManaged var order: NSNumber?
    @NSManaged var exercise: ExerciseEntity?
    @NSManaged var routine: WorkoutRoutineEntity?

}
