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
            navigationItem.leftBarButtonItem = nil
            prepareEditButtonForDetailView()
        } else {
            title = NSLocalizedString("New Routine", comment: "New routine as the title of the new routine viewcontroller")
            createBarButtonsForNewRoutine()
        }
    }

    private func prepareEditButtonForDetailView() -> Void {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("startEditing"))
        navigationItem.leftBarButtonItem = nil
    }

    private var isEditing = false
    func startEditing() -> Void {
        isEditing = true

        reloadSections()
        createEditingButtons()
    }

    private func reloadSections() -> Void {
        let exerciseSection = NSIndexSet(index: Sections.Exercises.rawValue)
        let metaSection = NSIndexSet(index: Sections.BaseInformations.rawValue)
        tableView.reloadSections(exerciseSection, withRowAnimation: .Automatic)
        tableView.reloadSections(metaSection, withRowAnimation: .Automatic)
    }

    func cancelEditing() -> Void {
        isEditing = false
        tableView.reloadData() // Maybe switch to something less aggressive?
        prepareEditButtonForDetailView()
    }

    func doneEditing() -> Void {
        isEditing = false
        prepareEditButtonForDetailView()
        reloadSections()
    }

    private func createEditingButtons() -> Void {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelEditing"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("doneEditing"))
    }

    override func didReceiveMemoryWarning() -> Void {
        super.didReceiveMemoryWarning()
    }

    private func createBarButtonsForNewRoutine() -> Void {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("finishCreationOfNewWorkoutRoutine"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelCreation"))
    }

    func fetchData() {
        tableView.reloadData()
    }

    func finishCreationOfNewWorkoutRoutine() -> Void {
        if !workoutNameTextField!.text!.isEmpty {
            if routineBuilder.isRoutineNameUnique(routineName: workoutNameTextField!.text!) {
                routineBuilder.setWorkoutRoutineName(workoutNameTextField!.text!)
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
            if let detail = detailWorkoutRoutine {
                if isEditing {
                    return detail.exercises.count + 1
                }
                return rowsInExerciseSectionInDetailViewWithoutEditing(detail)
            } else {
                return rowsInSectionForBuildingViewController()
            }
        } else if section == Sections.Notes.rawValue {
            return 1
        }
        return 0
    }

    private func rowsInExerciseSectionInDetailViewWithoutEditing(routine: WorkoutRoutine) -> Int {
        return routine.exercises.count
    }

    private func rowsInSectionForBuildingViewController() -> Int {
        if let count = routineBuilder.exercisesInWorkout() {
            return count + 1 // 1 for the button in the last row
        } else {
            routineBuilder.createEmptyRoutine()
            return routineBuilder.exercisesInWorkout()! + 1 // 1 for the button in the last row
        }
    }

    private var workoutNameTextField: UITextField?
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == Sections.BaseInformations.rawValue {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.textFieldCell,
                         forIndexPath: indexPath) as! TextFieldTableViewCell
            cell.textField.placeholder = NSLocalizedString("Workoutroutine Name",
              comment: "Name of the workout routine used as a placeholder in the creation ViewController of a new Workoutroutine")

            if let detail = detailWorkoutRoutine {
                cell.textField.text = detail.name
                // WorkoutRoutine has a PrimaryKey on the `name` field
                // it's not possible to edit it after the creation!
                cell.userInteractionEnabled = false
                cell.textField.userInteractionEnabled = false
            }

            workoutNameTextField = cell.textField

            return cell
        } else if indexPath.section == Sections.Exercises.rawValue {
            if let detail = detailWorkoutRoutine {
                if isEditing  && indexPath.row == detail.exercises.count {
                    let cell = tableView.dequeueReusableCellWithIdentifier(Constants.basicTextCell, forIndexPath: indexPath) 
                    cell.textLabel?.text = NSLocalizedString("Add another exercise...", comment: "Add new exercise in new workout Routine ViewController")
                    return cell
                }
                return cellForDetailWorkoutRoutine(indexPath, routine: detail)
            } else {
                return cellForRowInBuildingWorkoutRoutine(indexPath)
            }
        }

        return UITableViewCell()
    }

    private func cellForDetailWorkoutRoutine(indexPath: NSIndexPath, routine: WorkoutRoutine) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.basicTextCell, forIndexPath: indexPath) 

        let item = routine.exercises[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }

    private func cellForRowInBuildingWorkoutRoutine(indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == routineBuilder.exercisesInWorkout() {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.basicTextCell, forIndexPath: indexPath) 
            cell.textLabel?.text = NSLocalizedString("Add another exercise...", comment: "Add new exercise in new workout Routine ViewController")
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.basicTextCell, forIndexPath: indexPath) 
            let item = routineBuilder.getExerciseAtIndex(indexPath.row)
            cell.textLabel?.text = item!.name
            return cell
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == routineBuilder.exercisesInWorkout() {
                performSegueWithIdentifier(Constants.addExerciseSegue, sender: self)
            } else if let detail = detailWorkoutRoutine {
                if (indexPath.row == detail.exercises.count) && isEditing {
                    performSegueWithIdentifier(Constants.addExerciseSegue, sender: self)
                }
            }
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == Sections.Exercises.rawValue {
            if let exercisesInWorkout = routineBuilder.exercisesInWorkout() {
                if indexPath.row < exercisesInWorkout {
                    return true
                }
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

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == routineBuilder.exercisesInWorkout()! {
                return false
            }
            return true
        }
        return false
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        routineBuilder.swap(sourceIndexPath.row, to: destinationIndexPath.row)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.addExerciseSegue {
            var routine: WorkoutRoutine
            if let detailRoutine = detailWorkoutRoutine {
                routine = detailRoutine
            } else {
                routine = routineBuilder.getRawRoutine()!
            }

            let chooser = ExerciseChooserForRoutine(routine: routine, cb: { () -> Void in
                let section = NSIndexSet(index: Sections.Exercises.rawValue)
                self.tableView.reloadSections(section, withRowAnimation: .Automatic)
                }, beforeCb: { (id) -> Void in
            }, transaction: true)

            let navController = segue.destinationViewController as! UINavigationController
            let detail = navController.viewControllers.first as! ExerciseOverviewTableViewController
            detail.chooserForRoutine = chooser
        }
    }
}
