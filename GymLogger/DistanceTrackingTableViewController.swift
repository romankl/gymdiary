//
//  DistanceTrackingTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 17.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class DistanceTrackingTableViewController: BaseTrackerTableViewController {

    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        let realm = try! Realm()
        realm.beginWrite()
        exerciseToTrack?.detailPerformance[0].distance = (distanceTextField.text! as NSString).doubleValue
        exerciseToTrack?.detailPerformance[0].time = (timeTextField.text! as NSString).doubleValue
        try! realm.commitWrite()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Manually added exercises have no pre-built setup
        if exerciseToTrack?.detailPerformance.count == 0 {
            let realm = try! Realm()
            realm.beginWrite()
            let performance = Performance()
            realm.add(performance)
            exerciseToTrack?.detailPerformance.append(performance)
            try! realm.commitWrite()
        }

        if exerciseToTrack?.detailPerformance[0].time != 0 {
            timeTextField.text = "\(exerciseToTrack!.detailPerformance[0].time)"
        }

        if exerciseToTrack?.detailPerformance[0].distance != 0 {
            distanceTextField.text = "\(exerciseToTrack!.detailPerformance[0].distance)"
        }
    }
}
