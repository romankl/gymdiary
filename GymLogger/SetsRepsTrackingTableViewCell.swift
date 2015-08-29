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

    var atIndex: Int = 0

    var responder: SetsRepsValueChange!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        responder.valueIsChangingTo(textField.text, atIndex: atIndex, origin: textField == repsTextField ? .Reps : .Weight)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        responder.valueDidChangeTo(textField.text, atIndex: atIndex, origin: textField == repsTextField ? .Reps : .Weight)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        responder.valueDidChangeTo(textField.text, atIndex: atIndex, origin: textField == repsTextField ? .Reps : .Weight)
        textField.resignFirstResponder()
        return false
    }
}

enum TrackingInputField: Int {
    case Weight = 0, Reps
}
