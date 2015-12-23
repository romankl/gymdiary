//
//  SetsRepsDelegate.swift
//  GymLogger
//
//  Created by Roman Klauke on 24.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class SetsRepsDelegate: NSObject, UITableViewDelegate {

    init(exerciseToTrack: PerformanceExerciseMap, tableView: UITableView) {
        self.tableView = tableView
        self.exerciseToTrack = exerciseToTrack
    }

    private var tableView: UITableView
    private var exerciseToTrack: PerformanceExerciseMap

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.endEditing(true)

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let section = SetsRepsSections(section: indexPath.section)

        if section == .RepsSets {
            if indexPath.row == exerciseToTrack.detailPerformance.count {
                let realm = try! Realm()

                try! realm.write {
                    self.tableView.beginUpdates()
                    let performance = Performance()
                    self.exerciseToTrack.detailPerformance.append(performance)
                    let indexPathToReload = NSIndexPath(forRow: self.exerciseToTrack.detailPerformance.count, inSection: section.rawValue)
                    self.tableView.insertRowsAtIndexPaths([indexPathToReload], withRowAnimation: .Automatic)

                    let section = NSIndexSet(index: section.rawValue)
                    self.tableView.endUpdates()
                    self.tableView.reloadSections(section, withRowAnimation: .Automatic)
                }
            } else {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! SetsRepsTrackingTableViewCell
                cell.repsTextField.becomeFirstResponder()
            }
        }
    }
}
