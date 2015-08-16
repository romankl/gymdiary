//
//  DetailWorkoutTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class DetailWorkoutTableViewController: BaseOverviewTableViewController {

    private struct Constants {
        static let textFieldCell = "textFieldCell"
        static let basicTextCell = "basicTextCell"
        static let addExerciseSegue = "addExercise"
        static let sectionsInTableView = 3
        static let rowsInBaseInformations = 1
    }

    private enum Sections: Int {
        case BaseInformations = 0
        case Exercises
        case Notes
    }

    private var workout = WorkoutRoutine()
    private var routineBuilder = WorkoutRoutineBuilder()
    var detailWorkoutRoutine: WorkoutRoutine?
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.tableFooterView?.hidden = true

        if let detail = detailWorkoutRoutine {
            title = detail.name
        } else {
            title = NSLocalizedString("New Routine", comment: "New routine as the title of the new routine viewcontroller")
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

    override func fetchData() {
        tableView.reloadData()
    }

    func finishCreationOfNewWorkoutRoutine() -> Void {
        if !workoutNameTextField!.text.isEmpty {
            if routineBuilder.isRoutineNameUnique(routineName: workoutNameTextField!.text) {
                routineBuilder.setWorkoutRoutineName(workoutNameTextField!.text)
                routineBuilder.createNewObject()
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    func cancelCreation() -> Void {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Constants.sectionsInTableView
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.BaseInformations.rawValue {
            return Constants.rowsInBaseInformations
        } else if section == Sections.Exercises.rawValue {
            if let count = routineBuilder.exercisesInWorkout() {
                return count + 1 // 1 for the button in the last row
            } else {
                routineBuilder.createEmptyRoutine()
                return routineBuilder.exercisesInWorkout()! + 1 // 1 for the button in the last row
            }
        } else if section == Sections.Notes.rawValue {
            return 1
        }
        return 0
    }

    private var workoutNameTextField: UITextField?
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == Sections.BaseInformations.rawValue {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.textFieldCell, forIndexPath: indexPath) as! TextFieldTableViewCell
            cell.textField.placeholder = NSLocalizedString("Workoutroutine Name", comment: "Name of the workout routine used as a placeholder in the creation ViewController of a new Workoutroutine")
            workoutNameTextField = cell.textField
            return cell
        } else if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == routineBuilder.exercisesInWorkout() {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.basicTextCell, forIndexPath: indexPath) as! UITableViewCell
                cell.textLabel?.text = NSLocalizedString("Add another exercise...", comment: "Add new exercise in new workout Routine ViewController")
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.basicTextCell, forIndexPath: indexPath) as! UITableViewCell
                let item = routineBuilder.getExerciseAtIndex(indexPath.row)
                cell.textLabel?.text = item!.name
                return cell
            }
        }

        return UITableViewCell()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == Sections.BaseInformations.rawValue || indexPath.section == Sections.Notes.rawValue {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == routineBuilder.exercisesInWorkout() {
                performSegueWithIdentifier(Constants.addExerciseSegue, sender: self)
            }
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row < routineBuilder.exercisesInWorkout()! {
                return true
            }
        }

        return false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
                routineBuilder.removeExerciseAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.addExerciseSegue {
            let chooser = ExerciseChooserForRoutine(routine: routineBuilder.getRawRoutine()!, cb: { () -> Void in
                self.tableView.reloadData()
                }, beforeCb: { (id) -> Void in
                    self.tableView.reloadData()
            })

            let navController = segue.destinationViewController as! UINavigationController
            let detail = navController.viewControllers.first as! ExerciseOverviewTableViewController
            detail.chooserForRoutine = chooser
        }
    }
}
