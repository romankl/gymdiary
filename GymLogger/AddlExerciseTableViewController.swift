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

    private let exercise = Exercise()
    override func viewDidLoad() {
        super.viewDidLoad()

        exercise.bodyGroup = BodyParts.Arms.rawValue
        exercise.type = ExerciseType.Weight.rawValue
        selectedBodyPart.text = "\(BodyParts.Arms)"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let bodyPart = BodyParts(rawValue: exercise.bodyGroup)
        selectedBodyPart.text = "\(bodyPart!)"

        let type = ExerciseType(rawValue: exercise.type)
        exerciseType.text = "\(type!)"
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
        if !exerciseName.text.isEmpty {
            exercise.comment = exerciseComment.text.isEmpty ? "" : exerciseComment.text

            let realm = Realm()
            realm.write {
                realm.add(self.exercise)
            }

            presentingViewController?.dismissViewControllerAnimated(true, completion: completion)
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

    private struct Constants {
        static let segueType = "type"
        static let segueBodyPart = "bodyPart"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // TODO: Refactor
        if segue.identifier == Constants.segueBodyPart {
             let destination = segue.destinationViewController as! BodyPartChooserTableViewController
            destination.exercise = exercise
        } else {
            let destination = segue.destinationViewController as! ExerciseTypeChooserTableViewController
            destination.exercise = exercise
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
    }

    @IBOutlet weak var exerciseName: UITextField!
    @IBOutlet weak var exerciseComment: UITextView!
    @IBOutlet weak var selectedBodyPart: UILabel!
    @IBOutlet weak var exerciseType: UILabel!
}
