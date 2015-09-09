//
//  ExerciseOverviewTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 22.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class ExerciseOverviewTableViewController: BaseOverviewTableViewController {

    private struct Constants {
        static let cellIdentifier = "exerciseCell"
        static let detailSegue = "detailSegue"
        static let addSegue = "addExercise"
    }

    var chooserForRoutine: ExerciseChooserForRoutine? // Chooser for a workoutRoutine
    var chooserForWorkout: ExerciseToWorkoutChooser? // Chooser for a running workout
    private var items = Realm().objects(Exercise).filter("archived == false").sorted("name", ascending: true)
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()

        // used to fit it in one if
        if (chooserForRoutine != nil) || (chooserForWorkout != nil) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelChooser"))
            title = NSLocalizedString("Choose an exercise", comment: "Exercise chooser reached from new workout routine cntroller")
        } else {
            title = NSLocalizedString("Exercises", comment: "Exercise overview")
        }
    }

    func doneWithChooser() -> Void {
        let realm = Realm()
        if let isInRunningWorkout = chooserForWorkout {
            if let exercise = self.selectedExercise {
                realm.write {
                    let settingsValueForSets = ROKKeyValue.getInt(SettingsKeys.defaultSets, defaultValue: 5)
                    let planedSets = settingsValueForSets > 0 ? settingsValueForSets : 5 // TODO: Decide
                    let settingsValueForReps = ROKKeyValue.getInt(SettingsKeys.defaultReps, defaultValue: 5)
                    let planedReps = settingsValueForReps > 0 ? settingsValueForReps : 5 // TODO: Decide


                    let performanceMap = PerformanceExerciseMap()
                    for var i = 0; i < planedSets; i++ {
                        let performance = Performance()
                        performance.preReps = planedReps
                        performanceMap.detailPerformance.append(performance)

                        if exercise.type == ExerciseType.Distance.rawValue {
                            break
                        }
                    }

                    performanceMap.exercise = exercise
                    self.chooserForWorkout?.runningWorkout.performedExercises.append(performanceMap)
                    // TODO: Missing defaultReps/defaultSets
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: self.chooserForWorkout!.completion)
                }
            }
        } else {
            // if the routine is new and _not_ in the realm it could lead to an error, because
            // the primary key (routine-name) isn't available. Changing the primary key after the
            // `realm.add(...)` isnt possible.
            // To avoid such a scenario the chooser has field `withTransaction` that takes care of
            // the realm transaction. The UUID is necessary to handle the changes in the tableView
            // and to know which exercise is new for the routine
            selectedExercise?.volatileId = NSUUID().UUIDString
            chooserForRoutine?.beforeCompletion(id: NSUUID(UUIDString: selectedExercise!.volatileId)!)
            if chooserForRoutine!.withTransaction {
                realm.write{
                    self.chooserForRoutine?.workoutRoutine.exercises.append(self.selectedExercise!)
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: self.chooserForRoutine?.completion)
                }
            } else {
                chooserForRoutine?.workoutRoutine.exercises.append(selectedExercise!)
                presentingViewController?.dismissViewControllerAnimated(true, completion: chooserForRoutine?.completion)
            }
        }
    }

    func cancelChooser() -> Void {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func fetchData() {
        items =  Realm().objects(Exercise).sorted("name", ascending: true)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    private var selectedExercise: Exercise?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let inPicker = chooserForRoutine {
            markCellAndSetExercise(indexPath)
        } else if let inPicker = chooserForWorkout {
            markCellAndSetExercise(indexPath)
        }
    }

    private func markCellAndSetExercise(indexPath: NSIndexPath) {
        selectedExercise = items[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath)

        doneWithChooser()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let itemForCell = items[indexPath.row]
        cell.textLabel?.text = itemForCell.name
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let itemForCell = items[indexPath.row]

            let handler = ExerciseHandler()
            handler.loadExistingExercise(exerciseName: itemForCell.name)
            handler.deleteObject()
            // The super controller is notified upon saves and triggers a tableView.reloadData()
            // tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }  
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.detailSegue {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let exercise = items[indexPath!.row]
            let destination = segue.destinationViewController as! AddExerciseTableViewController
            destination.detailExercise = exercise
        } else {
            // TODO: Required?!
        }
    }
}
