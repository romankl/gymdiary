//
// Created by Roman Klauke on 08.02.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit

class BaseTabBarController: UITabBarController {

    private enum SegueIdentifer: String {
        case ToRunningWorkout = "switchToRunningWorkout"
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let context = DataCoordinator.sharedInstance.managedObjectContext
        if let workout = WorkoutEntity.activeWorkoutsInDb(usingContext: context) {
            performSegueWithIdentifier(SegueIdentifer.ToRunningWorkout.rawValue, sender: workout)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = SegueIdentifer(rawValue: segue.identifier!)!
        switch identifier {
        case .ToRunningWorkout:
            let destination = segue.destinationViewController as! UINavigationController
            let runningWorkoutController = destination.viewControllers.first as! RunningWorkoutTableViewController
            runningWorkoutController.runningWorkout = sender as! WorkoutEntity
            runningWorkoutController.initalSetupFinished = true
            break
        }
    }
}
