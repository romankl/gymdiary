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

        weightUnit.text = "\(WeightUnit(rawValue: ROKKeyValue.getInt(UnitChooserTableViewController.Constants.weight, defaultValue: 0))!.rawValue)"
        distanceUnit.text = "\(DistanceUnit(rawValue: ROKKeyValue.getInt(UnitChooserTableViewController.Constants.distance, defaultValue: 0))!.rawValue)"
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
            destination.key = UnitChooserTableViewController.Constants.weight
            destination.items = [WeightUnit]() as! AnyObject as! [(AnyObject)]
        } else if segue.identifier == Constants.distanceSegue {
            destination.key = UnitChooserTableViewController.Constants.distance
            destination.items = [DistanceUnit]() as! AnyObject as! [(AnyObject)]
        }
    }
}
