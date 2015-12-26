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
        if !exercise.isInsertObject {
            defaultBarButtons()
        } else {
            let context = DataCoordinator.sharedInstance.managedObjectContext
            exercise = ExerciseEntity.preprareNewExercise(context)
            exercise.isInsertObject = true
        }


        if exercise.bodyGroup != nil {
            selectedBodyPart.text = "\(exercise.bodyGroup)"
        } else {
            selectedBodyPart.text = "\(BodyParts(rawValue: 0))"
            exercise.bodyGroup = BodyParts.Chest.rawValue
        }

        if exercise.type != nil {
            exerciseType.text = "\(exercise.type)"
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
        toggleInteraction()
        exercise.comment = self.exerciseComment.text
        exercise.updatedAt = NSDate()

        let context = DataCoordinator.sharedInstance.managedObjectContext
        context.trySaveOrRollback()

        view.endEditing(true)

        isUpdatingExercise = false
        defaultBarButtons()
    }

    func cancelEditing() -> Void {
        toggleInteraction()
        defaultBarButtons()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !exercise.isInsertObject {
            // Always lock the name, because it's the Exercise table pk
            exerciseName.userInteractionEnabled = false

            selectedBodyPart!.text = "\(BodyParts(rawValue: (exercise.bodyGroup?.integerValue)!)!)"
            exerciseType!.text = "\(ExerciseType(rawValue: Int(exercise.type!))!)"
            exerciseName.text = exercise.name
            exerciseComment.text = exercise.comment

            title = exercise.name
            exerciseTypeCell.accessoryType = .None
            bodyPartCell.accessoryType = .None

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
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    var completion: (() -> Void)?
    /// Done Action
    @IBAction func done(sender: UIBarButtonItem) {
        view.endEditing(true)
        if !exerciseName.text!.isEmpty {
            if exerciseHandler.isExerciseNameUnique(exerciseName.text!) {

                exerciseHandler.setComment(exerciseComment.text.isEmpty ? "" : exerciseComment.text)
                exerciseHandler.setName(exerciseName.text!)
                exerciseHandler.createNewObject()

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

        var isUpdate = false
        var exercise: Exercise!
        if let e = detailExercise {
            exercise = e
            isUpdate = true
        } else {
            exercise = exerciseHandler.getRawExercise()
        }

        switch identifier {
        case .ToBodyPart:
            let destination = segue.destinationViewController as! BodyPartChooserTableViewController
            destination.exercise = exercise
            destination.isUpdate = isUpdate
            break
        case .ToExerciseType:
            let destination = segue.destinationViewController as! ExerciseTypeChooserTableViewController
            destination.exercise = exercise
            destination.isUpdate = isUpdate
            break
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
