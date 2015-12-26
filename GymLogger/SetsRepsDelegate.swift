//
//  SetsRepsDelegate.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import UIKit

class SetsRepsDelegate: NSObject, UITableViewDelegate {

    init(exerciseToTrack: PerformanceExerciseMapEntity, tableView: UITableView) {
        self.tableView = tableView
        self.exerciseToTrack = exerciseToTrack
    }

    private var tableView: UITableView
    private var exerciseToTrack: PerformanceExerciseMapEntity

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.endEditing(true)

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let section = SetsRepsSections(section: indexPath.section)

        if section == .RepsSets {
            if indexPath.row == exerciseToTrack.performanceCount() {
                self.tableView.beginUpdates()

                let context = DataCoordinator.sharedInstance.managedObjectContext
                // TODO: Default reps
                let performance = PerformanceEntity.preparePerformance(5,
                        inContext: context)
                self.exerciseToTrack.appendNewPerformance(performance)
                let indexPathToReload = NSIndexPath(forRow: exerciseToTrack.performanceCount(), inSection: section.rawValue)
                self.tableView.insertRowsAtIndexPaths([indexPathToReload], withRowAnimation: .Automatic)

                let section = NSIndexSet(index: section.rawValue)
                self.tableView.endUpdates()
                self.tableView.reloadSections(section, withRowAnimation: .Automatic)
            } else {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! SetsRepsTrackingTableViewCell
                cell.repsTextField.becomeFirstResponder()
            }
        }
    }
}
