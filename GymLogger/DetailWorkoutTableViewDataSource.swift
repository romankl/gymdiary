//
// Created by Roman Klauke on 22.12.15.
// Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit

class DetailWorkoutTableViewDataSource: NSObject, UITableViewDataSource {

    private var routine: WorkoutRoutineEntity
    var isEditing = false

    init(routine: WorkoutRoutineEntity) {
        self.routine = routine
    }

    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if !routine.isInsertObject {
            return DetailWorkoutSections.numberOfSectionsInDetailView()
        }

        return DetailWorkoutSections.numberOfSectionsInCreationView()
    }

    @objc func tableView(tableView: UITableView,
                         numberOfRowsInSection section: Int) -> Int {
        let workoutSection = DetailWorkoutSections(currentSection: section)

        switch workoutSection {
        case .BaseInformations, .Notes, .Actions:
            return workoutSection.numberOfRowsInSection()
        default:
            if !routine.isInsertObject {
                if isEditing {
                    return routine.countOfExercises() + 1
                }
                return rowsInExerciseSectionInDetailViewWithoutEditing()
            } else {
                return rowsInSectionForBuildingViewController()
            }
        }
    }

    private func rowsInExerciseSectionInDetailViewWithoutEditing() -> Int {
        return routine.countOfExercises()
    }

    private func rowsInSectionForBuildingViewController() -> Int {
        return routine.countOfExercises() + 1
    }

    @objc func tableView(tableView: UITableView,
                         canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        if section == DetailWorkoutSections.Exercises {
            if routine.isInsertObject {
                if indexPath.row < routine.countOfExercises() {
                    return true
                }
            } else {
                if indexPath.row < routine.countOfExercises() && isEditing {
                    return true
                }
            }
        }

        return false
    }

    @objc func tableView(tableView: UITableView,
                         commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                         forRowAtIndexPath indexPath: NSIndexPath) {
        let context = DataCoordinator.sharedInstance.managedObjectContext

        if editingStyle == .Delete {
            if isEditing || routine.isInsertObject {
                tableView.beginUpdates()
                routine.removeExercise(atIndex: indexPath.row, context: context)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.endUpdates()
            }
        }
    }

    @objc func tableView(tableView: UITableView,
                         canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        if section == DetailWorkoutSections.Exercises {
            if !routine.isInsertObject {
                if indexPath.row == routine.countOfExercises() + 1 {
                    return false
                }
            } else {
                if indexPath.row == routine.countOfExercises() {
                    return false
                }
            }

            return true
        }
        return false
    }

    @objc func tableView(tableView: UITableView,
                         moveRowAtIndexPath sourceIndexPath: NSIndexPath,
                         toIndexPath destinationIndexPath: NSIndexPath) {
        let fromRow = sourceIndexPath.row
        let toRow = destinationIndexPath.row

        routine.swapExercises(fromRow, to: toRow)
    }

    var workoutNameTextField: UITextField?
    var notesTextView: UITextView?
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        switch section {
        case .BaseInformations:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.TextFieldCell.rawValue,
                        forIndexPath: indexPath) as! TextFieldTableViewCell
                cell.textField.placeholder = NSLocalizedString("Workoutroutine Name",
                        comment: "Name of the workout routine used as a placeholder in the creation ViewController of a new Workoutroutine")

                if !routine.isInsertObject {
                    cell.textField.text = routine.name
                    // WorkoutRoutine has a PrimaryKey on the `name` field
                    // it's not possible to edit it after the creation!
                    cell.userInteractionEnabled = false
                    cell.textField.userInteractionEnabled = false
                }

                if isEditing {
                    cell.userInteractionEnabled = isEditing
                    cell.textField.userInteractionEnabled = isEditing
                }

                workoutNameTextField = cell.textField

                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants
                .ColorPickerCell.rawValue, forIndexPath: indexPath) as! ColorPickerCell
                return cell
            }
        case .Exercises:
            if !routine.isInsertObject {
                let exerciseCount = routine.countOfExercises()
                if isEditing && indexPath.row == exerciseCount {
                    let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.BasicTextFieldCell.rawValue, forIndexPath: indexPath)
                    cell.textLabel?.text = NSLocalizedString("Add another exercise...",
                            comment: "Add new exercise in new workout Routine ViewController")
                    return cell
                }
                return cellForDetailWorkoutRoutine(indexPath, tableView: tableView)
            } else {
                return cellForRowInBuildingWorkoutRoutine(indexPath, tableView: tableView)
            }

        case .Notes:
            let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.NotesTextFieldCell.rawValue,
                    forIndexPath: indexPath) as! TextViewInputCell
            notesTextView = cell.textView

            if !routine.isInsertObject {
                cell.textView.text = routine.comment
                cell.textView.userInteractionEnabled = isEditing
                cell.userInteractionEnabled = isEditing
            }

            return cell
        case .Actions:
            let row = DetailWorkoutActionSections(currentRow: indexPath.row)
            switch row {
            case .ArchiveAction:
                let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.ArchiveCell.rawValue,
                        forIndexPath: indexPath)

                if !routine.isInsertObject {
                    if ((routine.isArchived?.boolValue) != nil) {
                        if let archiveVal = routine.isArchived {
                            if archiveVal.boolValue {
                                cell.textLabel?.text = NSLocalizedString("Show In Workouts",
                                        comment: "Undo action for archived routines")
                            } else {
                                cell.textLabel?.text = row.textForCell()
                            }
                        }
                    }
                }
                return cell
            case .DeleteAction:
                let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.DeleteRoutineCell.rawValue,
                        forIndexPath: indexPath)
                cell.textLabel!.text = row.textForCell()
                return cell
            }
        }
    }

    private func cellForDetailWorkoutRoutine(indexPath: NSIndexPath,
                                             tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.BasicTextFieldCell.rawValue,
                forIndexPath: indexPath)

        if let item = routine.exerciseAtIndex(indexPath.row) {
            cell.textLabel?.text = item.name
        }

        return cell
    }

    private func cellForRowInBuildingWorkoutRoutine(indexPath: NSIndexPath, tableView: UITableView) -> UITableViewCell {
        if indexPath.row == routine.countOfExercises() {
            let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.BasicTextFieldCell.rawValue,
                    forIndexPath: indexPath)
            cell.textLabel?.text = NSLocalizedString("Add another exercise...",
                    comment: "Add new exercise in new workout Routine ViewController")
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.BasicTextFieldCell.rawValue,
                    forIndexPath: indexPath)
            let item = routine.exerciseAtIndex(indexPath.row)
            cell.textLabel?.text = item!.name
            return cell
        }
    }

    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let currentSection = DetailWorkoutSections(currentSection: section)
        return currentSection.footerForSection()
    }

}
