//
//  DetailExerciseTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class AddExerciseTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var exerciseName: UITextField!
    @IBOutlet weak var exerciseComment: UITextView!
    @IBOutlet weak var selectedBodyPart: UILabel!
    @IBOutlet weak var exerciseType: UILabel!

    @IBOutlet weak var exerciseTypeCell: UITableViewCell!
    @IBOutlet weak var bodyPartCell: UITableViewCell!

    var exercise: ExerciseEntity!
    override func viewDidLoad() {
        super.viewDidLoad()

        if exercise != nil {
            if !exercise.isInsertObject {
                defaultBarButtons()
            }
        } else {
            exercise = ExerciseEntity.preprareNewExercise(context)
            exercise.isInsertObject = true
        }


        if exercise.bodyGroup != nil {
            selectedBodyPart.text = "\(BodyParts(rawValue: exercise.bodyGroup!.integerValue)!)"
        } else {
            selectedBodyPart.text = "\(BodyParts(rawValue: 0))"
            exercise.bodyGroup = BodyParts.Chest.rawValue
        }

        if exercise.type != nil {
            exerciseType.text = "\(ExerciseType(rawValue: exercise.type!.integerValue)!)"
        } else {
            exerciseType.text = "\(ExerciseType(rawValue: 0))"
            exercise.type = ExerciseType.BodyWeight.rawValue
        }
    }

    func editExercise() -> Void {
        isUpdatingExercise = true

        toggleInteraction()
        createEditButtons()
    }

    private func defaultBarButtons() -> Void {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit,
                target: self,
                action: Selector("editExercise"))
    }

    private var isUpdatingExercise = false
    private func toggleInteraction() -> Void {
        bodyPartCell.userInteractionEnabled = isUpdatingExercise
        exerciseTypeCell.userInteractionEnabled = isUpdatingExercise
        exerciseComment.userInteractionEnabled = isUpdatingExercise
        exerciseName.userInteractionEnabled = isUpdatingExercise

        if isUpdatingExercise {
            exerciseTypeCell.accessoryType = .DisclosureIndicator
            bodyPartCell.accessoryType = .DisclosureIndicator
        } else {
            exerciseTypeCell.accessoryType = .None
            bodyPartCell.accessoryType = .None
        }
    }

    private func createEditButtons() -> Void {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel,
                target: self,
                action: Selector("cancelEditing"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done,
                target: self,
                action: Selector("doneEditing"))
    }

    func doneEditing() -> Void {
        guard let updatedExerciseName = exerciseName!.text else {
            return
        }

        if exercise.isNameUnique(updatedExerciseName, usingContext: context) {
            view.endEditing(true)
            isUpdatingExercise = false

            toggleInteraction()

            exercise.name = updatedExerciseName
            exercise.comment = exerciseComment.text

            title = exercise.name
            context.trySaveOrRollback()

            defaultBarButtons()
        } else {
            print("TODO: Alert")
        }
    }

    private var context: NSManagedObjectContext! {
        return DataCoordinator.sharedInstance.managedObjectContext
    }

    func cancelEditing() -> Void {
        isUpdatingExercise = false
        view.endEditing(true)

        context.rollback()
        prepareUi()

        toggleInteraction()
        defaultBarButtons()
    }

    private func prepareUi() -> Void {
        selectedBodyPart!.text = "\(BodyParts(rawValue: (exercise.bodyGroup?.integerValue)!)!)"
        exerciseType!.text = "\(ExerciseType(rawValue: Int((exercise.type?.integerValue)!))!)"

        if !context.hasChanges {
            exerciseName.text = exercise.name
            exerciseComment.text = exercise.comment

            title = exercise.name
            exerciseTypeCell.accessoryType = .None
            bodyPartCell.accessoryType = .None
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !exercise.isInsertObject {
            prepareUi()

            toggleInteraction()

            return
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// cancel Action
    @IBAction func cancel(sender: UIBarButtonItem) {
        view.endEditing(true)

        // At this point we have a complete new exercise, but the user decided
        // to cancel the creation. Just make sure that we delete the "old" obj
        context.deleteObject(exercise)

        if context.trySaveOrRollback() {
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    var completion: (() -> Void)?
    /// Done Action
    @IBAction func done(sender: UIBarButtonItem) {
        view.endEditing(true)

        if !exerciseName.text!.isEmpty {
            let nameForNewExercise = exerciseName.text!
            if exercise.isNameUnique(nameForNewExercise, usingContext: context) {
                exercise.comment = exerciseComment.text.isEmpty ? "" : exerciseComment.text
                exercise.name = nameForNewExercise
                exercise.lastTimeUsed = nil
                exercise.used = 0

                context.trySaveOrRollback()
                presentingViewController?.dismissViewControllerAnimated(true, completion: completion)
            } else {
                // TODO: Error!
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Missing name", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    private enum SegueIdentifers: String {
        case ToExerciseType = "type"
        case ToBodyPart = "bodyPart"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = SegueIdentifers(rawValue: segue.identifier!)!

        switch identifier {
        case .ToBodyPart:
            let destination = segue.destinationViewController as! BodyPartChooserTableViewController
            destination.exercise = exercise
            break
        case .ToExerciseType:
            let destination = segue.destinationViewController as! ExerciseTypeChooserTableViewController
            destination.exercise = exercise
            break
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
