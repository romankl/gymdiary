//
//  RunningWorkoutTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 27.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift


class RunningWorkoutTableViewController: UITableViewController {

    var workoutRoutine: WorkoutRoutine?

    private let runningWorkout: Workout = Workout()

    override func viewWillAppear(animated: Bool) {
        if let routine = workoutRoutine {
            runningWorkout.name = routine.name
            runningWorkout.active = true

            for exercise in routine.exercises {
                let performanceMap = PerformanceExerciseMap()

                performanceMap.exercise = exercise
                runningWorkout.performedExercises.append(performanceMap)
            }

            runningWorkout.basedOnWorkout = routine
        } else {
            runningWorkout.name = NSLocalizedString("Free Workout", comment: "Free wrkout as a cell title in a new workoutcontroller")
        }

        let realm = Realm()
        realm.write {
            realm.add(self.runningWorkout)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private struct Constants {
        static let sections = 3
        static let exerciseCellIdentifier = "exerciseCell"
    }

    @IBAction func finishWorkout(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelWorkout(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    // TODO: Implement Comparable
    private enum Sections: Int {
        case MetaInformation = 0, Exercises
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Constants.sections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.Exercises.rawValue {
            return runningWorkout.performedExercises.count + 1
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.exerciseCellIdentifier, forIndexPath: indexPath) as! UITableViewCell

        if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == runningWorkout.performedExercises.count {
                cell.textLabel?.text = NSLocalizedString("Add Exercise", comment: "...")
            } else {
                cell.textLabel?.text = runningWorkout.performedExercises[indexPath.row].exercise.name
            }
        } else {
            cell.textLabel?.text = "Dummy"
        }

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
}
