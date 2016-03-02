//
// Created by Roman Klauke on 02.03.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit


class CircleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if let fillColor = color {
            backgroundColor = fillColor
        } else {
            backgroundColor = .greenColor()
        }
        layer.cornerRadius = frame.width / 2
    }

    var color: UIColor? {
        didSet {
            backgroundColor = color
        }
    }
}
