//
//  SetsRepsDataSource.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import UIKit

class SetsRepsDataSource: NSObject, UITableViewDataSource, UITextFieldDelegate {

    init(exerciseToTrack: PerformanceExerciseMapEntity,
         tableView: UITableView,
         editing: Bool) {
        self.exerciseToTrack = exerciseToTrack
        self.tableView = tableView
        self.isEditingEnabled = editing
    }

    private var isEditingEnabled = false
    private var exerciseToTrack: PerformanceExerciseMapEntity
    private var tableView: UITableView
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if !isEditingEnabled {
            return false
        }

        let section = SetsRepsSections(section: indexPath.section)
        return section.canEditRows() && (indexPath.row < exerciseToTrack.performanceCount())
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return SetsRepsSections.totalSections()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let convertedSection = SetsRepsSections(section: section)
        switch convertedSection {
        case .Meta, .Notes: return 1
        case .RepsSets:
            let performanceCount = exerciseToTrack.performanceCount()
            return isEditingEnabled ? performanceCount + 1 : performanceCount
        }
    }

    private struct Constants {
        static let metaCellIdentifier = "metaCell"
        static let repsSetsIdentifier = "repsCell"
        static let setsControllingCell = "setsController"
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = SetsRepsSections(section: indexPath.section)
        switch section {
        case .Notes, .Meta:
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.metaCellIdentifier, forIndexPath: indexPath)
            return cell
        case .RepsSets:
            if indexPath.row == exerciseToTrack.performanceCount() {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.setsControllingCell, forIndexPath: indexPath)
                cell.textLabel?.text = NSLocalizedString("Add another set", comment: "Add a new set in the weightExercise ViewController")
                return cell
            }

            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.repsSetsIdentifier, forIndexPath: indexPath) as! SetsRepsTrackingTableViewCell
            cell.weightTextField.delegate = self
            cell.repsTextField.delegate = self

            cell.orderingLabel.text = "\(indexPath.row + 1)" // +1 because indexPath.row starts at 0

            let item = exerciseToTrack.detailPerformance(indexPath.row)

            cell.weightTextField.text = item.weight?.floatValue > 0 ? "\(item.weight!)" : nil
            cell.repsTextField.text = item.reps?.integerValue > 0 ? "\(item.reps!)" : nil

            if !isEditingEnabled {
                cell.repsTextField.userInteractionEnabled = false
                cell.weightTextField.userInteractionEnabled = false
            }

            return cell
        }
    }

    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.endEditing(true) // hide all keyboards to close all open realms

            tableView.beginUpdates()
            let context = DataCoordinator.sharedInstance.managedObjectContext
            let itemToDelete = self.exerciseToTrack.detailPerformance(indexPath.row)
            context.deleteObject(itemToDelete)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

            // TODO: Decide where to save
            context.trySaveOrRollback()
            tableView.endUpdates()
        }
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        // prevents a crash. The UITextField calls the textFieldDidEndEditing after the "real"
        // move event and at this point there could be another realm write transaction. we force the keyboard
        // to endEditing and the delegate calls textFieldDidEndEditing.
        // And to add another guard, we call endEditing if the user hits the "edit" buttons
        tableView.endEditing(true)

        self.exerciseToTrack.move(from: fromIndexPath.row, to: toIndexPath.row)

        let sectionSet = NSIndexSet(index: fromIndexPath.section)
        tableView.reloadSections(sectionSet, withRowAnimation: .Automatic)
    }

    // Override to support conditional rearranging of the table view.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }


    func textFieldDidEndEditing(textField: UITextField) {
        let containedInCell = textField.superview!.superview as! SetsRepsTrackingTableViewCell
        let indexPath = tableView.indexPathForCell(containedInCell)

        if textField == containedInCell.weightTextField {
            updateValueInPerformanceDbObject(textField.text!, atIndex: indexPath!.row, origin: .Weight)
        } else {
            updateValueInPerformanceDbObject(textField.text!, atIndex: indexPath!.row, origin: .Reps)
        }
    }

    private func updateValueInPerformanceDbObject(newValue: String, atIndex: Int, origin: TrackingInputField) {
        let casted = (newValue as NSString).doubleValue
        let performance = exerciseToTrack.detailPerformance(atIndex)

        if origin == .Weight {
            performance.weight = casted
        } else {
            performance.reps = Int(casted)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
