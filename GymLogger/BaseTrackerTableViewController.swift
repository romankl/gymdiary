//
//  BaseTrackerTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 17.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

public class BaseTrackerTableViewController: UITableViewController, UITextFieldDelegate {
    public var runningWorkout: Workout?
    public var exerciseToTrack: PerformanceExerciseMap?

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = exerciseToTrack?.exercise.name
    }

    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
