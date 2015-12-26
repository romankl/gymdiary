//
// Created by Roman Klauke on 26.12.15.
// Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {

    func trySaveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            print("error while saving: \(error)")
            rollback()
            return false
        }
    }

    func trySaveOrFail(msg: String = "") -> Bool {
        do {
            try save()
            return true
        } catch {
            fatalError(msg)
            return false
        }
    }

}
