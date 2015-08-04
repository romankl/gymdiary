//
//  UnitChooserTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 04.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class UnitChooserTableViewController: BaseChooserTableViewController {
    struct Constants {
        static let weight = "weight_unit"
        static let distance = "distance_unit"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func textForCell(indexPath: NSIndexPath) -> String {
        // TODO use the key from super class to determine which obj is used
        if items[indexPath.row] is WeightUnit {
            return "\(items[indexPath.row] as! WeightUnit)"
        } else if items[indexPath.row] is DistanceUnit {
            return "\(items[indexPath.row] as! DistanceUnit)"
        }

        return ""
    }

    override func prepareBackSegue(indexPath: NSIndexPath) {
        if key == Constants.weight {
            let item = items[indexPath.row] as! WeightUnit
            ROKKeyValue.put(Constants.weight, int: item.rawValue)
        } else if key == Constants.distance {
            let item = items[indexPath.row] as! DistanceUnit
            ROKKeyValue.put(Constants.distance, int: item.rawValue)
        }
    }
}
