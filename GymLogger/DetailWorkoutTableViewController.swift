//
//  DetailWorkoutTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class DetailWorkoutTableViewController: UITableViewController {

    private struct Constants {
        static let textFieldCell = "textFieldCell"
        static let basicTextCell = "basicTextCell"
        static let addExerciseSegue = "addExercise"
    }

    private enum Sections: Int {
        case BaseInformations = 0
        case Exercises
        case Notes
    }

    private var workout = WorkoutRoutine()
    var detailWorkout: WorkoutRoutine?
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.tableFooterView?.hidden = true

        if let detail = detailWorkout {
            // TODO:
        } else {
            createBarButtonsForNewRoutine()
        }
    }

    override func didReceiveMemoryWarning() -> Void {
        super.didReceiveMemoryWarning()
    }

    private func createBarButtonsForNewRoutine() -> Void {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("finishCreationOfNewWorkoutRoutine"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelCreation"))
    }

    func finishCreationOfNewWorkoutRoutine() -> Void {
        if !workoutNameTextField!.text.isEmpty {

        } else {
            workout.name = workoutNameTextField!.text
        }
    }

    func cancelCreation() -> Void {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.BaseInformations.rawValue {
            return 1
        } else if section == Sections.Exercises.rawValue {
            return workout.exercises.count + 1 // 1 for the button in the last row
        } else if section == Sections.Notes.rawValue {
            return 1
        }
        return 0
    }

    private var workoutNameTextField: UITextField?
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == Sections.BaseInformations.rawValue {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.textFieldCell, forIndexPath: indexPath) as! TextFieldTableViewCell
            cell.textField.placeholder = NSLocalizedString("Workoutroutine Name", comment: "Name of the workout routine used as a placeholder in the creation ViewController of a new WOrkoutroutine")
            workoutNameTextField = cell.textField
            return cell
        } else if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == workout.exercises.count {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.basicTextCell, forIndexPath: indexPath) as! UITableViewCell
                cell.textLabel?.text = NSLocalizedString("Add another exercise...", comment: "Add new exercise in new workout Routine ViewController")
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.basicTextCell, forIndexPath: indexPath) as! UITableViewCell
                let item = workout.exercises[indexPath.row]
                cell.textLabel?.text = item.name
                return cell
            }
        }

        return UITableViewCell()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == Sections.BaseInformations.rawValue {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.selected = false
        } else if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == workout.exercises.count {
                performSegueWithIdentifier(Constants.addExerciseSegue, sender: self)
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
}
