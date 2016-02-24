//
// Created by Roman Klauke on 24.02.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func toHexString() -> String {
        let color = self.CGColor
        let count = CGColorGetNumberOfComponents(color)
        let components = CGColorGetComponents(color)
        let formatPattern = "%02x%02x%02x"

        var result: NSString

        if count == 2 {
            let whiteColorCode = components[0] * 255
            result = NSString(format: formatPattern as NSString, whiteColorCode, whiteColorCode,
                whiteColorCode)
        } else {
            result = NSString(format: formatPattern as NSString, components[0] * 255, components[1] * 255,
                components[2] * 255)
        }

        print("\(result)")
        return result as String
    }
}
