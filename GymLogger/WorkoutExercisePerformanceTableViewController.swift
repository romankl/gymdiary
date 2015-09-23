//
//  WorkoutExercisePerformanceTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 03.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class WorkoutExercisePerformanceTableViewController: UITableViewController {

    var performanceItems: PerformanceExerciseMap!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3 // 0.: Meta 1: Reps/Sets 2: Adds
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.Exercises.rawValue {
            return performanceItems.detailPerformance.count
        }
        return 1
    }

    private enum Sections: Int {
        case Exercises = 0, Meta, Summary
    }

}
