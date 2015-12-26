//
//  DetailWorkoutTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class DetailWorkoutTableViewController: UITableViewController {

    private var detailTableViewDelegate: DetailWorkoutTableViewDelegate!
    private var detailTableViewDataSource: DetailWorkoutTableViewDataSource!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let exerciseSection = NSIndexSet(index: DetailWorkoutSections.Exercises.rawValue)
        tableView.reloadSections(exerciseSection, withRowAnimation: .Automatic)
    }


    var detailWorkoutRoutine: WorkoutRoutineEntity?
    override func viewDidLoad() {
        super.viewDidLoad()

        let context = DataCoordinator.sharedInstance.managedObjectContext

        if let detail = detailWorkoutRoutine {
            title = detail.name
            navigationItem.leftBarButtonItem = nil
            prepareEditButtonForDetailView()
        } else {
            detailWorkoutRoutine = WorkoutRoutineEntity.prepareForNewWorkout(context)
            title = NSLocalizedString("New Routine",
                    comment: "New routine as the title of the new routine viewcontroller")
            createBarButtonsForNewRoutine()

            tableView.setEditing(true, animated: true)

            detailWorkoutRoutine!.isInsertObject = true
        }

        detailTableViewDataSource = DetailWorkoutTableViewDataSource(routine: detailWorkoutRoutine!)
        detailTableViewDelegate = DetailWorkoutTableViewDelegate(routine: detailWorkoutRoutine!,
                tableView: self.tableView) {
            (identifier) -> Void in
            self.performSegueWithIdentifier(identifier, sender: self)
        }

        detailTableViewDelegate.actionCallback = {
            (action: DetailWorkoutDelegateAction) -> Void in
            switch action {
            case .Delete:
                context.deleteObject(self.detailWorkoutRoutine!)
                context.trySaveOrRollback()
                self.navigationController?.popToRootViewControllerAnimated(true)
            case .Archive:
                if let routineEntity = self.detailWorkoutRoutine {

                    if ((routineEntity.isArchived?.boolValue) != nil) {
                        if let archiveVal = routineEntity.isArchived {
                            if archiveVal.boolValue {
                                routineEntity.isArchived = 0
                            } else {
                                routineEntity.isArchived = 1
                            }
                        }
                    }
                }

                context.trySaveOrRollback()

                let actionSection = NSIndexSet(index: DetailWorkoutSections.Actions.rawValue)
                self.tableView.reloadSections(actionSection, withRowAnimation: .Automatic)
            }
        }


        tableView.dataSource = detailTableViewDataSource
        tableView.delegate = detailTableViewDelegate

        tableView.allowsSelectionDuringEditing = true

        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.tableFooterView?.hidden = true
    }

    private func prepareEditButtonForDetailView() -> Void {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit,
                target: self,
                action: Selector("startEditing"))
        navigationItem.leftBarButtonItem = nil
    }

    private var isEditing = false
    func startEditing() -> Void {
        isEditing = true

        tableView.setEditing(isEditing, animated: true)

        detailTableViewDataSource.isEditing = isEditing
        detailTableViewDelegate.isEditing = isEditing

        reloadSections()
        createEditingButtons()
    }

    func cancelEditing() -> Void {
        isEditing = false
        tableView.setEditing(isEditing, animated: true)

        detailTableViewDataSource.isEditing = isEditing
        detailTableViewDelegate.isEditing = isEditing

        tableView.reloadData() // Maybe switch to something less aggressive?
        prepareEditButtonForDetailView()
    }

    private func reloadSections() -> Void {
        let exerciseSection = NSIndexSet(index: DetailWorkoutSections.Exercises.rawValue)
        let metaSection = NSIndexSet(index: DetailWorkoutSections.BaseInformations.rawValue)
        tableView.reloadSections(exerciseSection, withRowAnimation: .Automatic)
        tableView.reloadSections(metaSection, withRowAnimation: .Automatic)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done,
                target: self,
                action: Selector("finishCreationOfNewWorkoutRoutine"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel,
                target: self,
                action: Selector("cancelCreation"))
    }

    func fetchData() {
        tableView.reloadData()
    }

    func finishCreationOfNewWorkoutRoutine() -> Void {
        guard let workoutNameTextField = detailTableViewDataSource.workoutNameTextField,
        let workoutNotesTextView = detailTableViewDataSource.notesTextView,
        let routine = detailWorkoutRoutine else {
            return
        }


        if !workoutNameTextField.text!.isEmpty {
            if routine.isNameUnique(routineName: workoutNameTextField.text!) {
                routine.name = workoutNameTextField.text!
                routine.comment = workoutNotesTextView.text

                let context = DataCoordinator.sharedInstance.managedObjectContext
                if context.trySaveOrRollback() {
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Missing name",
                        message: "A name for the new routine is missing",
                        preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok",
                        style: .Default,
                        handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Missing name",
                    message: "A name for the new routine is missing",
                    preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok",
                    style: .Default,
                    handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    func cancelCreation() -> Void {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == DetailWorkoutConstants.AddExerciseSegue.rawValue {
            guard let routine = detailWorkoutRoutine else {
                return
            }

            let chooser = ExerciseChooserForRoutine(routine: routine, cb: {
                () -> Void in
                let section = NSIndexSet(index: DetailWorkoutSections.Exercises.rawValue)
                self.tableView.reloadSections(section, withRowAnimation: .Automatic)
            }, beforeCb: {
                (id) -> Void in
            })

            let navController = segue.destinationViewController as! UINavigationController
            let detail = navController.viewControllers.first as! ExerciseOverviewTableViewController
            detail.chooserForRoutine = chooser
        }
    }
}
