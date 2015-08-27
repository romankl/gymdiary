//
//  SetsRepsTrackingTableViewCell.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class SetsRepsTrackingTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var orderingLabel: UILabel!

    var responder: SetsRepsValueChange!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        responder.valueIsChangingTo(textField.text)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        responder.valueDidChangeTo(textField.text)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        responder.valueDidChangeTo(textField.text)
        textField.resignFirstResponder()
        return false
    }
}
