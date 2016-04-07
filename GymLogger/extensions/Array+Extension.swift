//
// Created by Roman Klauke on 09.04.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit


extension SequenceType where Generator.Element: Equatable {
    func countElement(v: Generator.Element) throws -> Int {
        return try reduce(0) {
            if $1 == v {
                return $0 + 1
            }
            return $0
        }
    }
}
