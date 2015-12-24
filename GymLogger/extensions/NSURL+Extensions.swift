//
// Created by Roman Klauke on 24.12.15.
// Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation

extension NSURL {
    static func applicationDocumentsDirectory() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }
}
