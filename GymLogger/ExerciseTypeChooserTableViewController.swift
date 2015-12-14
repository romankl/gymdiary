//
//  ExerciseTypeChooserTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class ExerciseTypeChooserTableViewController: UITableViewController {

    var exercise: Exercise?
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        title = NSLocalizedString("Exercise Type", comment: "Exercise Title in AddExerciseViewController used as a ViewController Title")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    let items = [ExerciseType.BodyWeight,
                 ExerciseType.OlympicBarbell,
                 ExerciseType.Dumbbell,
                 ExerciseType.Distance]
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.accessoryType = .None

        if let selectedExercise = exercise {
            if items[indexPath.row].rawValue == selectedExercise.type {
                cell.accessoryType = .Checkmark
                oldCell = cell
            }
        }
        cell.textLabel?.text = "\(items[indexPath.row])"

        return cell
    }


    var oldCell: UITableViewCell?
    var isUpdate = false
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = oldCell {
            oldCell?.accessoryType = .None
        }

        let newCell = tableView.cellForRowAtIndexPath(indexPath)
        newCell?.selected = false
        newCell?.accessoryType = .Checkmark

        if isUpdate {
            let realm = try! Realm()
            try! realm.write {
                self.exercise?.type = self.items[indexPath.row].rawValue
            }
        } else {
            exercise?.type = items[indexPath.row].rawValue
        }
        oldCell = newCell
    }
}
