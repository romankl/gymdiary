//
//  SettingsTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 04.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    private struct Constants {
        static let weightSegue = "weightUnit"
        static let distanceSegue = "distanceUnit"
    }

    @IBOutlet weak var weightUnit: UILabel!
    @IBOutlet weak var distanceUnit: UILabel!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let weightUnitInSettings = NSUserDefaults.standardUserDefaults().integerForKey(SettingsKeys.weight)
        let distanceUnitInSettings = NSUserDefaults.standardUserDefaults().integerForKey(SettingsKeys.distance)
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
}
