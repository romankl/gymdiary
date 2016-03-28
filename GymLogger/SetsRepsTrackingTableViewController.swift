//
//  SetsRepsTrackingTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 17.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class SetsRepsTrackingTableViewController: BaseTrackerTableViewController {

    private var setsRepsDataSource: SetsRepsDataSource!
    private var setsRepsDelegate: SetsRepsDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEditingEnabled {
            self.navigationItem.rightBarButtonItem = self.editButtonItem()
        } else {
            createDefaultEditButtonForDetails()
        }

        setsRepsDataSource = SetsRepsDataSource(exerciseToTrack: exerciseToTrack!,
                tableView: self.tableView,
                editing: isEditingEnabled)
        setsRepsDelegate = SetsRepsDelegate(exerciseToTrack: exerciseToTrack!, tableView: self.tableView)

        tableView.dataSource = setsRepsDataSource
        tableView.delegate = setsRepsDelegate
    }

    private func createDefaultEditButtonForDetails() -> Void {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit,
                target: self,
                action: #selector(SetsRepsTrackingTableViewController.editSetsReps))
        navigationItem.leftBarButtonItem = nil
    }

    func editSetsReps() -> Void {
        isEditingEnabled = !isEditingEnabled

        tableView.allowsSelectionDuringEditing = isEditingEnabled
        if isEditingEnabled {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel,
                    target: self,
                    action: #selector(SetsRepsTrackingTableViewController.editSetsReps))

            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done,
                    target: self,
                    action: #selector(SetsRepsTrackingTableViewController.doneEditingSetsReps))
        } else {
            createDefaultEditButtonForDetails()
        }

        setsRepsDataSource.isEditingEnabled = isEditingEnabled

        tableView.setEditing(isEditingEnabled, animated: true)

        let setsRepsSection = NSIndexSet(index: SetsRepsSections.RepsSets.rawValue)
        tableView.reloadSections(setsRepsSection, withRowAnimation: .Automatic)
    }

    func doneEditingSetsReps() -> Void {
        createDefaultEditButtonForDetails()
        isEditingEnabled = false
        setsRepsDataSource.isEditingEnabled = isEditingEnabled

        tableView.setEditing(isEditingEnabled, animated: true)
        let setsRepsSection = NSIndexSet(index: SetsRepsSections.RepsSets.rawValue)
        tableView.reloadSections(setsRepsSection, withRowAnimation: .Automatic)

        let context = DataCoordinator.sharedInstance.managedObjectContext
        context.trySaveOrRollback()
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.endEditing(true)
    }
}
