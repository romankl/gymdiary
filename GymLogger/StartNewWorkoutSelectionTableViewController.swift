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
    private struct Constants {
        static let sectionsWithRoutines = 3
        static let sectionsWithoutRoutines = 2
        static let dateInformationCellIdentifier = "dateInformation"
        static let datePickerCellIdentifier = "datePicker"
        static let freeWorkoutCellIdentifier = "freeWorkout"
        static let workoutRoutineCellIdentifier = "workoutRoutine"
    }

    private enum Sections: Int {
        case DateInformation = 0, FreeFormWorkout, WorkoutRoutine
    }

    private var dataSource: StartNewWorkoutDataSource!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = nil // The super- class provides "Edit" as the left bar button

        dataSource = StartNewWorkoutDataSource(items: self.items)
        tableView.dataSource = dataSource
        fetchData()
    }

    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private var items = try! Realm().objects(WorkoutRoutine).sorted("name", ascending: true)
    override func fetchData() {
        items = try! Realm().objects(WorkoutRoutine).sorted("name", ascending: true)
        tableView.reloadData()
    }

    // MARK: - Table view data source


    private var prevCell: UITableViewCell?
    private var selectedRoutine: WorkoutRoutine?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == Sections.WorkoutRoutine.rawValue || indexPath.section == Sections.FreeFormWorkout.rawValue {
            let cell = tableView.cellForRowAtIndexPath(indexPath)

            if indexPath.section == Sections.WorkoutRoutine.rawValue {
                selectedRoutine = items[indexPath.row]
            } else {
                selectedRoutine = nil
            }

            performSegueWithIdentifier(SegueIdentifier.StartNewWorkout.rawValue, sender: cell)
        }
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

            if let _ = selectedRoutine {
                destination.workoutRoutine = selectedRoutine
            }
            break
        }
    }
}
