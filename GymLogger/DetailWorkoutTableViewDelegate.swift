//
// Created by Roman Klauke on 22.12.15.
// Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit
import ROKUIKit

class DetailWorkoutTableViewDelegate: NSObject, UITableViewDelegate {
    private var routine: WorkoutRoutineEntity
    private var tableView: UITableView!

    var isEditing = false

    private let colors = WorkoutColors.allColors()

    private var colorCallback: ((color:UIColor) -> Void)
    init(routine: WorkoutRoutineEntity,
         tableView: UITableView,
         colorForWorkout: ((color:UIColor) -> Void),
         segueTriger: ((identifier:String) -> Void)) {
        self.tableView = tableView
        self.segueTrigger = segueTriger
        self.colorCallback = colorForWorkout
        self.routine = routine

        guard let color = routine.color else {
            return
        }

        // conv
        guard let convertedColor = NSKeyedUnarchiver.unarchiveObjectWithData(color) as? UIColor else {
            return
        }

        colorForDetailView = convertedColor
    }

    private var colorForDetailView: UIColor?

    private var colorToSelectedCell: UIColor!

    private var segueTrigger: ((identifier:String) -> Void)
    var actionCallback: ((action:DetailWorkoutDelegateAction) -> Void)?

    @objc func tableView(tableView: UITableView,
                         didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch section {
        case .Exercises:
            if !routine.isInsertObject {
                let exerciseCount = routine.countOfExercises()
                if (indexPath.row == exerciseCount) && isEditing {
                    segueTrigger(identifier: DetailWorkoutConstants.AddExerciseSegue.rawValue)
                }
            } else {
                if indexPath.row == routine.countOfExercises() {
                    segueTrigger(identifier: DetailWorkoutConstants.AddExerciseSegue.rawValue)
                }
            }
        case .Actions:
            let row = DetailWorkoutActionSections(currentRow: indexPath.row)
            switch row {
            case .DeleteAction:
                if let cb = actionCallback {
                    cb(action: .Delete)
                }
            case .ArchiveAction:
                if let cb = actionCallback {
                    cb(action: .Archive)
                }
            }
        default:
            return
        }
    }

    @objc func tableView(tableView: UITableView,
                         willDisplayCell cell: UITableViewCell,
                         forRowAtIndexPath indexPath: NSIndexPath) {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        switch section {
        case .BaseInformations:
            guard let tableViewCell = cell as? ColorPickerCell else {
                return
            }

            tableViewCell.setCollectionViewDelegateAndDataSource(self)
            tableViewCell.setOffSetAndReloadData()
            tableViewCell.collectionViewOffset = collectionViewOffset[indexPath.row] ?? 0

            if !(isEditing || routine.isInsertObject) {
                tableViewCell.colorCollectionView.scrollEnabled = false
                if let color = colorForDetailView {
                    if let index = colors.indexOf(color) {
                        let indexPathForColor = NSIndexPath(index: index)
                        tableViewCell.colorCollectionView.scrollToItemAtIndexPath(indexPathForColor,
                                atScrollPosition: .Left, animated: true)
                    }
                }
            }

        default: return
        }
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }


    @objc func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        switch section {
        case .BaseInformations:
            guard let tableViewCell = cell as? ColorPickerCell else {
                return
            }
            collectionViewOffset[indexPath.row] = tableViewCell.collectionViewOffset

        default: return
        }
    }

    private var collectionViewOffset = [Int: CGFloat]()
    private var previousItem: ColorCell?
    private var previousColor: UIColor?
    private var previousItemIndexPath: NSIndexPath?
}


enum DetailWorkoutDelegateAction {
    case Archive, Delete
}

extension DetailWorkoutTableViewDelegate: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DetailWorkoutConstants
        .CollectionViewColorCell.rawValue,
                forIndexPath: indexPath) as! ColorCell

        let currentColor = colors[indexPath.row]
        cell.circleColor = currentColor

        if let prevIndexPath = previousItemIndexPath {
            if prevIndexPath.row == indexPath.row {
                cell.marked = true
            }
        }

        if let detailColor = colorForDetailView {
            if detailColor.hash == currentColor.hash {
                cell.marked = true
            }
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let color = colors[indexPath.row]
        colorCallback(color: color)

        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ColorCell else {
            return
        }

        if let path = previousItemIndexPath {
            if let prevCell = collectionView.cellForItemAtIndexPath(path) as? ColorCell {
                prevCell.marked = false
                prevCell.circleColor = previousColor
            }
        }

        previousColor = cell.circleColor
        previousItemIndexPath = indexPath

        cell.marked = true
    }
}
