//
// Created by Roman Klauke on 22.12.15.
// Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DetailWorkoutTableViewDataSource: NSObject, UITableViewDataSource {

    private var routineBuilder: WorkoutRoutineBuilder?
    var detailWorkoutRoutine: WorkoutRoutine?
    var isEditing = false

    init(builder: WorkoutRoutineBuilder, routine: WorkoutRoutine?) {
        self.routineBuilder = builder
        self.detailWorkoutRoutine = routine
    }

    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let _ = detailWorkoutRoutine {
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
            if let detail = detailWorkoutRoutine {
                if isEditing {
                    return detail.exercises.count + 1
                }
                return rowsInExerciseSectionInDetailViewWithoutEditing(detail)
            } else {
                return rowsInSectionForBuildingViewController()
            }
        }
    }

    private func rowsInExerciseSectionInDetailViewWithoutEditing(routine: WorkoutRoutine) -> Int {
        return routine.exercises.count
    }

    private func rowsInSectionForBuildingViewController() -> Int {
        if let count = routineBuilder?.exercisesInWorkout() {
            return count + 1 // 1 for the button in the last row
        } else {
            routineBuilder?.createEmptyRoutine()
            return (routineBuilder?.exercisesInWorkout()!)! + 1 // 1 for the button in the last row
        }
    }

    @objc func tableView(tableView: UITableView,
                         canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        if section == DetailWorkoutSections.Exercises {
            if let exercisesInWorkout = routineBuilder?.exercisesInWorkout() {
                if indexPath.row < exercisesInWorkout {
                    return true
                }
            } else if let detail = detailWorkoutRoutine {
                if indexPath.row < detail.exercises.count && isEditing {
                    return true
                }
            }
        }

        return false
    }

    @objc func tableView(tableView: UITableView,
                         commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                         forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let detail = detailWorkoutRoutine {
                if isEditing {
                    // TODO: extract to another extension
                    let realm = try! Realm()
                    try! realm.write {
                        detail.exercises.removeAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    }
                }
            } else if let builder = routineBuilder {
                builder.removeExerciseAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
    }

    @objc func tableView(tableView: UITableView,
                         canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        if section == DetailWorkoutSections.Exercises {
            if let detail = detailWorkoutRoutine {
                if indexPath.row == detail.exercises.count + 1 {
                    return false
                }
            } else if let builder = routineBuilder {
                if indexPath.row == builder.exercisesInWorkout()! {
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
        routineBuilder?.swap(sourceIndexPath.row, to: destinationIndexPath.row)
    }

    var workoutNameTextField: UITextField?
    var notesTextView: UITextView?
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        switch section {
        case .BaseInformations:
            let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.TextFieldCell.rawValue,
                    forIndexPath: indexPath) as! TextFieldTableViewCell
            cell.textField.placeholder = NSLocalizedString("Workoutroutine Name",
                    comment: "Name of the workout routine used as a placeholder in the creation ViewController of a new Workoutroutine")

            if let detail = detailWorkoutRoutine {
                cell.textField.text = detail.name
                // WorkoutRoutine has a PrimaryKey on the `name` field
                // it's not possible to edit it after the creation!
                cell.userInteractionEnabled = false
                cell.textField.userInteractionEnabled = false
            }

            workoutNameTextField = cell.textField

            return cell

        case .Exercises:
            if let detail = detailWorkoutRoutine {
                if isEditing && indexPath.row == detail.exercises.count {
                    let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.BasicTextFieldCell.rawValue, forIndexPath: indexPath)
                    cell.textLabel?.text = NSLocalizedString("Add another exercise...",
                            comment: "Add new exercise in new workout Routine ViewController")
                    return cell
                }
                return cellForDetailWorkoutRoutine(indexPath, routine: detail, tableView: tableView)
            } else {
                return cellForRowInBuildingWorkoutRoutine(indexPath, tableView: tableView)
            }

        case .Notes:
            let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.NotesTextFieldCell.rawValue,
                    forIndexPath: indexPath) as! TextViewInputCell
            notesTextView = cell.textView

            if let detail = detailWorkoutRoutine {
                cell.textView.text = detail.comment
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

                if let detail = detailWorkoutRoutine {
                    if detail.isArchived {
                        cell.textLabel?.text = NSLocalizedString("Show In Workouts",
                                comment: "Undo action for archived routines")
                    } else {
                        cell.textLabel?.text = row.textForCell()
                    }
                }
                return cell
            case .DeleteAction:
                let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.DeleteRoutineCell.rawValue,
                        forIndexPath: indexPath)
                cell.textLabel!.text = row.textForCell()
                return cell
            }
        default:
            return UITableViewCell()
        }
    }

    private func cellForDetailWorkoutRoutine(indexPath: NSIndexPath,
                                             routine: WorkoutRoutine,
                                             tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.BasicTextFieldCell.rawValue,
                forIndexPath: indexPath)

        let item = routine.exercises[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }

    private func cellForRowInBuildingWorkoutRoutine(indexPath: NSIndexPath, tableView: UITableView) -> UITableViewCell {
        if indexPath.row == routineBuilder?.exercisesInWorkout() {
            let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.BasicTextFieldCell.rawValue,
                    forIndexPath: indexPath)
            cell.textLabel?.text = NSLocalizedString("Add another exercise...",
                    comment: "Add new exercise in new workout Routine ViewController")
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(DetailWorkoutConstants.BasicTextFieldCell.rawValue,
                    forIndexPath: indexPath)
            let item = routineBuilder?.getExerciseAtIndex(indexPath.row)
            cell.textLabel?.text = item!.name
            return cell
        }
    }
}
