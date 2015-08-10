//
//  SettingsTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 04.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {

    private struct Constants {
        static let weightSegue = "weightUnit"
        static let distanceSegue = "distanceUnit"
    }

    @IBOutlet weak var defaultReps: UITextField!
    @IBOutlet weak var defaultSets: UITextField!

    @IBOutlet weak var weightUnit: UILabel!
    @IBOutlet weak var distanceUnit: UILabel!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let weightUnitInSettings = ROKKeyValue.getInt(SettingsKeys.weight, defaultValue: 0)
        let distanceUnitInSettings = ROKKeyValue.getInt(SettingsKeys.distance, defaultValue: 0)
        weightUnit.text = "\(WeightUnit(rawValue: weightUnitInSettings)!)"
        distanceUnit.text = "\(DistanceUnit(rawValue: distanceUnitInSettings)!)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! UnitChooserTableViewController
        if segue.identifier == Constants.weightSegue {
            destination.key = SettingsKeys.weight
            destination.weightItems = [WeightUnit.Kg, WeightUnit.Lb]
        } else if segue.identifier == Constants.distanceSegue {
            destination.key = SettingsKeys.distance
            destination.distanceItems = [DistanceUnit.Kilometres, DistanceUnit.Miles]
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        let input = textField.text.isEmpty ? 5 : textField.text.toInt()!

        if textField == defaultReps {
            ROKKeyValue.put(SettingsKeys.defaultReps, int: input)
        } else if textField == defaultSets {
            ROKKeyValue.put(SettingsKeys.defaultSets, int: input)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
