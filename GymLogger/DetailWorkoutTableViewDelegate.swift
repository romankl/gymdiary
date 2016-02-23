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

    init(routine: WorkoutRoutineEntity,
         tableView: UITableView,
         segueTriger: ((identifier:String) -> Void)) {
        self.tableView = tableView
        self.segueTrigger = segueTriger
        self.routine = routine
    }

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

    @objc func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let section = DetailWorkoutSections(currentSection: indexPath.section)

        switch section {
        case .BaseInformations:
            guard let tableViewCell = cell as? ColorPickerCell else {
                return
            }

            tableViewCell.setCollectionViewDelegateAndDataSource(self)
            tableViewCell.setOffSetAndReloadData()
            tableViewCell.collectionViewOffset = collectionViewOffset[indexPath.row] ?? 0
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

        cell.circleColor = colors[indexPath.row]

        return cell
    }
}
