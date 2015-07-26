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
        static let sections = 3
        static let dateInformationCellIdentifier = "dateInformation"
        static let datePickerCellIdentifier = "datePicker"
        static let freeWorkoutCellIdentifier = "freeWorkout"
        static let workoutRoutineCellIdentifier = "workoutRoutine"
    }

    private enum Sections: Int {
        case DateInformation = 0, FreeFormWorkout, WorkoutRoutine
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return Constants.sections
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
        if indexPath.section == Sections.WorkoutRoutine.rawValue {
            prevCell?.accessoryType = .None
            let newCell = tableView.cellForRowAtIndexPath(indexPath)
            newCell?.selected = false

            newCell?.accessoryType = .Checkmark
            prevCell = newCell
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
}
