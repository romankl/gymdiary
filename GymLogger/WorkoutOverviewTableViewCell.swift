//
// Created by Roman Klauke on 29.02.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit


@objc
class WorkoutOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var colorView: CircleView!
    @IBOutlet weak var titleLabel: UILabel!

    var color: UIColor? {
        didSet {
            colorView.color = color
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
