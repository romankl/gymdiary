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
            title = routine.name
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
        let realm = Realm()
        realm.write {
            self.runningWorkout.endedAt = NSDate()
            self.runningWorkout.active = false

            var totalTime = Double()
            var totalDistance = Double()
            var totalReps = 0
            var totalWeight = Double()
            for performed in self.runningWorkout.performedExercises {
                for sets in performed.detailPerformance {
                    if sets.time == 0 {
                        totalReps += sets.reps
                        totalWeight += totalWeight
                    } else {
                        totalTime += sets.time
                    }
                }
            }

            self.runningWorkout.totalDistance = totalDistance
            self.runningWorkout.totalReps = totalReps
            self.runningWorkout.totalWeight = totalWeight
            self.runningWorkout.totalRunningTime = totalTime

            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func cancelWorkout(sender: UIBarButtonItem) {
        let realm = Realm()
        realm.write {
            realm.delete(self.runningWorkout)
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
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
        } else if indexPath.section == Sections.MetaInformation.rawValue {
            cell.textLabel?.text = "Meta"
        } else {
            cell.textLabel?.text = "Dummy"
        }

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if indexPath.section == Sections.Exercises.rawValue {
                let realm = Realm()
                realm.write {
                    self.runningWorkout.performedExercises.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == Sections.Exercises.rawValue {
            if indexPath.row == runningWorkout.performedExercises.count {
                return false
            }
            return true
        }
        return false
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
}
