//
//  NewWorkoutSelectionTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 26.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class StartNewWorkout: BaseOverviewTableViewController {
    private var dataSource: StartNewWorkoutDataSource!
    private var workoutDelegate: StartNewWorkoutDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = nil // The super- class provides "Edit" as the left bar button

        dataSource = StartNewWorkoutDataSource(items: self.items)
        workoutDelegate = StartNewWorkoutDelegate(items: self.items) {
            (cell) -> Void in
            self.performSegueWithIdentifier(SegueIdentifier.StartNewWorkout.rawValue, sender: cell)
        }



        tableView.dataSource = dataSource
        tableView.delegate = workoutDelegate
        fetchData()
    }

    @IBAction func datePickerValueChanged(sender: UIDatePicker) {

    }

    private var items = try! Realm().objects(WorkoutRoutine).sorted("name", ascending: true)
    override func fetchData() {
        items = try! Realm().objects(WorkoutRoutine).sorted("name", ascending: true)
        tableView.reloadData()
    }

    private enum SegueIdentifier: String {
        case StartNewWorkout = "startWorkout"
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = SegueIdentifier(rawValue: segue.identifier!)!
        switch identifier {
        case .StartNewWorkout:
            let navController = segue.destinationViewController as! UINavigationController
            let destination = navController.viewControllers.first as! RunningWorkoutTableViewController

            if let routine = workoutDelegate.selectedRoutine {
                destination.workoutRoutine = routine
            }
            break
        }
    }
}
