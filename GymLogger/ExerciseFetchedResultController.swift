//
// Created by Roman Klauke on 13.02.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//

import Foundation
import CoreData

class ExerciseFetchedResultController: NSFetchedResultsController {
    override func sectionIndexTitleForSectionName(sectionName: String) -> String? {
        super.sectionIndexTitleForSectionName(sectionName)

        let fullName = "\(BodyParts(rawValue: Int(sectionName)!)!)"
        let firstCharacterIndex = fullName.startIndex.advancedBy(0)
        return String(fullName[firstCharacterIndex])
    }

}
