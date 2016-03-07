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

    @IBOutlet weak var shortWorkoutName: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    struct ViewData {
        let title: String
        let usedLastTime: String
        let color: UIColor
    }

    var viewData: ViewData? {
        didSet {
            titleLabel?.text = viewData?.title
            subTitle?.text = viewData?.usedLastTime
            color = viewData?.color
        }
    }
}

extension WorkoutOverviewTableViewCell.ViewData {
    init(title: String, lastUsed: NSDate?, color: UIColor) {
        self.title = title
        self.color = color

        if let used = lastUsed {
            self.usedLastTime = "\(used)"
        } else {
            self.usedLastTime = NSLocalizedString("Never", comment: "never -- used as date refernce")
        }
    }
}
