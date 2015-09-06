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
        static let startWorkoutSegue = "startWorkout"
    }

    private enum Sections: Int {
        case DateInformation = 0, FreeFormWorkout, WorkoutRoutine
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = nil // The super- class provides "Edit" as the left bar button

        fetchData()
    }

    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func fetchData() {
        items = Realm().objects(WorkoutRoutine).sorted("name", ascending: true)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Realm().objects(WorkoutRoutine).count > 0 ? Constants.sectionsWithRoutines : Constants.sectionsWithoutRoutines
    }

    private var items = Realm().objects(WorkoutRoutine).sorted("name", ascending: true)
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.DateInformation.rawValue || section == Sections.FreeFormWorkout.rawValue {
            return 1
        }
        return items.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Sections.WorkoutRoutine.rawValue {
            return NSLocalizedString("Workout Routines", comment: "Workout Routine section header in start newWorkout")
        } else if section == Sections.DateInformation.rawValue {
            return NSLocalizedString("Workout Date", comment: "Date and time informations for a new workout in startNewWorkout")
        } else if section == Sections.FreeFormWorkout.rawValue {
            return NSLocalizedString("Free workout", comment: "...")
        }

        return ""
    }

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == Sections.FreeFormWorkout.rawValue {
            return NSLocalizedString("Use a free form workout to build a one-time workout without a predefined routine", comment: "Section footer for freeform workout in startNewWorkout")
        } else if section == Sections.WorkoutRoutine.rawValue {
            return NSLocalizedString("Workout routines can be extended by addtional exercises", comment: "section footer for workout routines in startNewWorkout")
        }
        return ""
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    private var selectedDate = NSDate()
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == Sections.DateInformation.rawValue {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.dateInformationCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
                cell.detailTextLabel?.text = "\(selectedDate)"
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.datePickerCellIdentifier, forIndexPath: indexPath) as! DatePickerTableViewCell
                cell.datePicker.date = selectedDate
                return cell
            }
        } else if indexPath.section == Sections.FreeFormWorkout.rawValue {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.freeWorkoutCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = NSLocalizedString("Free workout", comment: "Free workout in a tableViewCell in startNewWorkout")
            return cell
        } else if indexPath.section == Sections.WorkoutRoutine.rawValue {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.workoutRoutineCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = items[indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }

    private var prevCell: UITableViewCell?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == Sections.WorkoutRoutine.rawValue || indexPath.section == Sections.FreeFormWorkout.rawValue {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            performSegueWithIdentifier(Constants.startWorkoutSegue, sender: cell)
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.startWorkoutSegue {
            let navController = segue.destinationViewController as! UINavigationController
            let destination = navController.viewControllers.first as! RunningWorkoutTableViewController

            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            if indexPath?.section == Sections.WorkoutRoutine.rawValue {
                destination.workoutRoutine = items[indexPath!.row]
            }
        }
    }
}
