//
//  SetsRepsTrackingTableViewCell.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class SetsRepsTrackingTableViewCell: UITableViewCell {
    @IBOutlet weak var setsTextFIeld: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var orderingLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
