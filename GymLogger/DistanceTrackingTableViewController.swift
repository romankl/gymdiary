//
//  DistanceTrackingTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 17.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class DistanceTrackingTableViewController: BaseTrackerTableViewController {

    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        let performance = exerciseToTrack?.detailPerformance(0)
        performance?.distance = (distanceTextField.text! as NSString).doubleValue
        performance?.time = (timeTextField.text! as NSString).doubleValue
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let context = DataCoordinator.sharedInstance.managedObjectContext

        // Manually added exercises have no pre-built setup
        if exerciseToTrack?.performanceCount() == 0 {
            let performance = PerformanceEntity.preparePerformance(1, inContext: context)
            exerciseToTrack?.appendNewPerformance(performance)
        }

        if exerciseToTrack?.detailPerformance(0).time != 0 {
            timeTextField.text = "\(exerciseToTrack?.detailPerformance(0).time)"
        }

        if exerciseToTrack?.detailPerformance(0).distance != 0 {
            distanceTextField.text = "\(exerciseToTrack?.detailPerformance(0).distance)"
        }
    }
}
