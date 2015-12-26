//
//  BaseEntity.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.12.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import Foundation
import CoreData


class BaseEntity: NSManagedObject {


    override func awakeFromInsert() {
        super.awakeFromInsert()

        // Basic record tracking fields
        createdAt = NSDate()
        updatedAt = NSDate()
    }

}
