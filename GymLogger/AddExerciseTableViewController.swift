//
//  DetailExerciseTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class AddExerciseTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var exerciseName: UITextField!
    @IBOutlet weak var exerciseComment: UITextView!
    @IBOutlet weak var selectedBodyPart: UILabel!
    @IBOutlet weak var exerciseType: UILabel!

    @IBOutlet weak var exerciseTypeCell: UITableViewCell!
    @IBOutlet weak var bodyPartCell: UITableViewCell!

    private let exerciseHandler = ExerciseHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = detailExercise {
            defaultBarButtons()
        } else {
            exerciseHandler.createBasicExercise()
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
        if let exercise = detailExercise {
            let realm = try! Realm()
            try! realm.write {
                exercise.comment = self.exerciseComment.text
                exercise.updatedAt = NSDate()
            }
        }

        view.endEditing(true)

        isUpdatingExercise = false
        defaultBarButtons()
    }

    func cancelEditing() -> Void {
        toggleInteraction()
        defaultBarButtons()
    }

    var detailExercise: Exercise?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let exercise = detailExercise {
            // Always lock the name, because it's the Exercise table pk
            exerciseName.userInteractionEnabled = false

            selectedBodyPart!.text = "\(BodyParts(rawValue: exercise.bodyGroup)!)"
            exerciseType!.text = "\(ExerciseType(rawValue: exercise.type)!)"
            exerciseName.text = exercise.name
            exerciseComment.text = exercise.comment

            title = exercise.name
            exerciseTypeCell.accessoryType = .None
            bodyPartCell.accessoryType = .None

            toggleInteraction()

            return
        }


        if let body = exerciseHandler.getBodyPart() {
            selectedBodyPart.text = "\(body)"
        } else {
            selectedBodyPart.text = "\(BodyParts(rawValue: 0))"
            exerciseHandler.setBodyPart(.Chest)
        }

        if let type = exerciseHandler.getExerciseType() {
            exerciseType.text = "\(type)"
        } else {
            exerciseType.text = "\(ExerciseType(rawValue: 0))"
            exerciseHandler.setExerciseType(.BodyWeight)
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
