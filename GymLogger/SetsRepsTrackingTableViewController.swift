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
        }

        setsRepsDataSource = SetsRepsDataSource(exerciseToTrack: exerciseToTrack!,
                tableView: self.tableView,
                editing: isEditingEnabled)
        setsRepsDelegate = SetsRepsDelegate(exerciseToTrack: exerciseToTrack!, tableView: self.tableView)

        tableView.dataSource = setsRepsDataSource
        tableView.delegate = setsRepsDelegate
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.endEditing(true)
    }
}
