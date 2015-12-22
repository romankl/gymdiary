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

    private var detailTableViewDelegate: DetailWorkoutTableViewDelegate!
    private var detailTableViewDataSource: DetailWorkoutTableViewDataSource!

    private var workout = WorkoutRoutine()
    private var routineBuilder = WorkoutRoutineBuilder()
    var detailWorkoutRoutine: WorkoutRoutine?
    override func viewDidLoad() {
        super.viewDidLoad()

        detailTableViewDataSource = DetailWorkoutTableViewDataSource(builder: routineBuilder,
                routine: detailWorkoutRoutine)
        detailTableViewDelegate = DetailWorkoutTableViewDelegate(routineBuilder: routineBuilder,
                detailRoutine: detailWorkoutRoutine,
                tableView: self.tableView) {
            (identifier) -> Void in
            self.performSegueWithIdentifier(identifier, sender: self)
        }


        tableView.dataSource = detailTableViewDataSource
        tableView.delegate = detailTableViewDelegate


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

        detailTableViewDataSource.isEditing = isEditing
        detailTableViewDelegate.isEditing = isEditing

        reloadSections()
        createEditingButtons()

        tableView.reloadData()
    }

    private func reloadSections() -> Void {
        let exerciseSection = NSIndexSet(index: DetailWorkoutSections.Exercises.rawValue)
        let metaSection = NSIndexSet(index: DetailWorkoutSections.BaseInformations.rawValue)
        tableView.reloadSections(exerciseSection, withRowAnimation: .Automatic)
        tableView.reloadSections(metaSection, withRowAnimation: .Automatic)
    }

    func cancelEditing() -> Void {
        isEditing = false
        tableView.setEditing(isEditing, animated: true)

        detailTableViewDataSource.isEditing = isEditing
        detailTableViewDelegate.isEditing = isEditing

        tableView.reloadData() // Maybe switch to something less aggressive?
        prepareEditButtonForDetailView()
    }

    func doneEditing() -> Void {
        isEditing = false

        tableView.setEditing(false, animated: true)

        detailTableViewDataSource.isEditing = isEditing
        detailTableViewDelegate.isEditing = isEditing

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
        guard let workoutNameTextField = detailTableViewDataSource.workoutNameTextField else {
            return
        }

        guard let workoutNotesTextView = detailTableViewDataSource.notesTextView else {
            return
        }

        if !workoutNameTextField.text!.isEmpty {
            if routineBuilder.isRoutineNameUnique(routineName: workoutNameTextField.text!) {
                routineBuilder.setWorkoutRoutineName(workoutNameTextField.text!)
                routineBuilder.setWorkoutRoutineComment(workoutNotesTextView.text)
                routineBuilder.createNewObject()
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Missing name", message: "A name for the new routine is missing", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Missing name", message: "A name for the new routine is missing", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    func cancelCreation() -> Void {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == DetailWorkoutConstants.AddExerciseSegue.rawValue {
            var routine: WorkoutRoutine
            if let detailRoutine = detailWorkoutRoutine {
                routine = detailRoutine
            } else {
                routine = routineBuilder.getRawRoutine()!
            }

            let chooser = ExerciseChooserForRoutine(routine: routine, cb: {
                () -> Void in
                let section = NSIndexSet(index: DetailWorkoutSections.Exercises.rawValue)
                self.tableView.reloadSections(section, withRowAnimation: .Automatic)
            }, beforeCb: {
                (id) -> Void in
            }, transaction: true)

            let navController = segue.destinationViewController as! UINavigationController
            let detail = navController.viewControllers.first as! ExerciseOverviewTableViewController
            detail.chooserForRoutine = chooser
        }
    }
}
