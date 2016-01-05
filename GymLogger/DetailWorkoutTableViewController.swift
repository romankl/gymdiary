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

        if let detail = detailWorkoutRoutine {
            if !detail.isInsertObject {
                detailTableViewDataSource!.workoutNameTextField?.text = detailWorkoutRoutine?.name
            }
        }

        detailTableViewDelegate.actionCallback = {
            (action: DetailWorkoutDelegateAction) -> Void in
            switch action {
            case .Delete:
                self.context.deleteObject(self.detailWorkoutRoutine!)
                self.context.trySaveOrRollback()
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

                self.context.trySaveOrRollback()

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

        context.rollback()

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

        detailWorkoutRoutine!.name = detailTableViewDataSource!.workoutNameTextField?.text
        detailWorkoutRoutine!.comment = detailTableViewDataSource!.notesTextView?.text

        title = detailWorkoutRoutine!.name
        context.trySaveOrRollback()

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

    private var context: NSManagedObjectContext {
        return DataCoordinator.sharedInstance.managedObjectContext
    }

    func cancelCreation() -> Void {
        if let detail = detailWorkoutRoutine {
            context.deleteObject(detail)
            if context.trySaveOrRollback() {
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == DetailWorkoutConstants.AddExerciseSegue.rawValue {
            guard let routine = detailWorkoutRoutine else {
                return
            }

            let chooser = ExerciseChooserForRoutine(routine: routine)

            let navController = segue.destinationViewController as! UINavigationController
            let detail = navController.viewControllers.first as! ExerciseOverviewTableViewController
            detail.chooserForRoutine = chooser
        }
    }
}
