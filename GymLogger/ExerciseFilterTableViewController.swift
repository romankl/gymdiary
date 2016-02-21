//
// Created by Roman Klauke on 21.02.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//


import Foundation
import UIKit

class ExerciseFilterTableViewController: UITableViewController {

    private let bodyParts = BodyParts.allBodyParts()
    private let equipment = ExerciseType.allTypes()

    private struct Constants {
        static let segueIdentifier = "filterExercise"
        static let cellIdentifier = "cell"
    }

    var chooserForRoutine: ExerciseChooserForRoutine?
    var chooserForWorkout: ExerciseToWorkoutChooser?

    override func viewDidLoad() {
        super.viewDidLoad()


        if let _ = chooserForWorkout {
            prepareCancelButton()
        }

        if let _ = chooserForRoutine {
            prepareCancelButton()
        }
    }

    private func prepareCancelButton() -> Void {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancel"))
        navigationItem.leftBarButtonItem = cancelButton
    }

    func cancel() -> Void {
        presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }

    @available(iOS 5.0, *) override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let cell = sender as? UITableViewCell else {
            return
        }

        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }

        guard let filterSection = ExerciseFilterSection(rawValue: indexPath.section) else {
            return
        }


        var predicate: NSPredicate
        switch filterSection {
        case .BodyPart:
            let item = bodyParts[indexPath.row]
            predicate = NSPredicate(format: "%K == %i", ExerciseEntity.Keys.bodyGroup.rawValue, item
            .rawValue)
            break
        case .Equipment:
            let item = equipment[indexPath.row]
            predicate = NSPredicate(format: "%K == %i", ExerciseEntity.Keys.type.rawValue, item.rawValue)
            break
        default:
            predicate = NSPredicate(format: "1 == 1") // TODO: figure out, how to query all rows in thisscenario
            break
        }

        let destination = segue.destinationViewController as! ExerciseOverviewTableViewController
        destination.exerciseFilterPredicate = predicate
        destination.chooserForRoutine = chooserForRoutine
        destination.chooserForWorkout = chooserForWorkout
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, titleForHeaderInSection section:
            Int) ->
            String? {
        guard let filterSection = ExerciseFilterSection(rawValue: section) else {
            return ""
        }
        return filterSection.description()
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filterSection = ExerciseFilterSection(rawValue: section) else {
            return 0
        }

        switch filterSection {
        case .All: return 1
        case .BodyPart: return bodyParts.count
        case .Equipment: return equipment.count
        }
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let filterSection = ExerciseFilterSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCellWithIdentifier(ExerciseFilterTableViewController.Constants
        .cellIdentifier, forIndexPath: indexPath)

        switch filterSection {
        case .BodyPart:
            cell.textLabel?.text = "\(bodyParts[indexPath.row])"
            break
        case .Equipment:
            cell.textLabel?.text = "\(equipment[indexPath.row])"
            break
        case .All:
            cell.textLabel?.text = NSLocalizedString("All Exercises", comment: "all")
            break
        }

        return cell
    }

    @available(iOS 2.0, *) override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ExerciseFilterSection.numberOfSections()
    }
}
