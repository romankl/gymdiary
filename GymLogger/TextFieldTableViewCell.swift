//
//  TextFieldTableViewCell.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
