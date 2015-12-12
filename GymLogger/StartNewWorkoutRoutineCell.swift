//
//  StartNewWorkoutRoutineCell.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import UIKit

class StartNewWorkoutRoutineCell: UITableViewCell {

    struct ViewData {
        let title: String
        let usedLastTime: String
    }

    var viewData: ViewData? {
        didSet {
            textLabel?.text = viewData?.title
            detailTextLabel?.text = viewData?.usedLastTime
        }
    }
}

extension StartNewWorkoutRoutineCell.ViewData {
    init(title: String, lastUsed: NSDate) {
        self.title = title
        self.usedLastTime = "\(lastUsed)"
    }
}
