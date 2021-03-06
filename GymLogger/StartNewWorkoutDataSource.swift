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

        chosenWorkoutDateFormatter.dateStyle = .NoStyle
        chosenWorkoutDateFormatter.timeStyle = .MediumStyle

        lastUsedDateFormatter.dateStyle = .MediumStyle
        lastUsedDateFormatter.timeStyle = .NoStyle

        super.init()
    }

    private let chosenWorkoutDateFormatter: NSDateFormatter = NSDateFormatter()
    private let lastUsedDateFormatter: NSDateFormatter = NSDateFormatter()
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
                cell.detailTextLabel?.text = chosenWorkoutDateFormatter.stringFromDate(selectedDate)
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
            guard let cell = tableView.dequeueReusableCellWithIdentifier(Constants.workoutRoutineCellIdentifier,
                    forIndexPath: indexPath) as? WorkoutOverviewTableViewCell else {
                return UITableViewCell()
            }
            let item = items[indexPath.row]


            let title = item.name
            if let lastTimeUsed = item.lastTimeUsed {
                cell.subTitle.text = NSLocalizedString("Last usage: ", comment: "Last usage: ") +
                        lastUsedDateFormatter.stringFromDate(lastTimeUsed)
            } else {
                cell.subTitle.text = NSLocalizedString("Never", comment: "never")
            }

            guard let routineTitle = title else {
                return UITableViewCell() // just in case..
            }
            cell.titleLabel.text = routineTitle


            let index = routineTitle.startIndex.advancedBy(0)
            cell.shortWorkoutName.text = "\(routineTitle[index])"

            guard let color = NSKeyedUnarchiver.unarchiveObjectWithData(item.color!) as? UIColor else {
                return cell
            }

            cell.color = color

            return cell
        }
    }
}
