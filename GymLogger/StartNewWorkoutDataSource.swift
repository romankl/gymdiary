//
//  StartNewWorkoutDataSource.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.09.15.
//  Copyright © 2015 Roman Klauke. All rights reserved.
//

import UIKit


class StartNewWorkoutDataSource: NSObject, UITableViewDataSource {

    private struct Constants {
        static let dateInformationCellIdentifier = "dateInformation"
        static let datePickerCellIdentifier = "datePicker"
        static let freeWorkoutCellIdentifier = "freeWorkout"
        static let workoutRoutineCellIdentifier = "workoutRoutine"
    }

    init(items: [WorkoutRoutineEntity]) {
        self.items = items

        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .MediumStyle

        super.init()
    }

    private var dateFormatter: NSDateFormatter
    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return StartNewWorkoutSections.numberOfSections()
    }

    var items: [WorkoutRoutineEntity]
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let convertedSection = StartNewWorkoutSections(section: section)
        switch convertedSection {
        case .Meta, .FreeFormWorkout:
            return convertedSection.rowsInSection()
        default:
            return items.count
        }
    }

    @objc func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = StartNewWorkoutSections(section: section)
        return section.titleHeader()
    }

    @objc func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = StartNewWorkoutSections(section: section)
        return section.titleFooter()
    }

    @objc func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    private var selectedDate = NSDate()
    @objc func tableView(tableView: UITableView,
                         cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = StartNewWorkoutSections(section: indexPath.section)
        switch section {
        case .Meta:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.dateInformationCellIdentifier,
                        forIndexPath: indexPath)
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(selectedDate)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.datePickerCellIdentifier,
                        forIndexPath: indexPath) as! DatePickerTableViewCell
                cell.datePicker.date = selectedDate
                return cell
            }
        case .FreeFormWorkout:
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.freeWorkoutCellIdentifier,
                    forIndexPath: indexPath)
            cell.textLabel?.text = NSLocalizedString("Free workout",
                    comment: "Free workout in a tableViewCell in startNewWorkout")

            return cell
        case .WorkoutRoutine:
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.workoutRoutineCellIdentifier,
                    forIndexPath: indexPath) as! StartNewWorkoutRoutineCell
            let title = items[indexPath.row].name
            let lastTimeUsed = items[indexPath.row].lastTimeUsed

            guard let routineTitle = title else {
                return UITableViewCell() // just in case..
            }

            cell.viewData = StartNewWorkoutRoutineCell.ViewData(title: routineTitle, lastUsed: lastTimeUsed)

            return cell
        }
    }
}
