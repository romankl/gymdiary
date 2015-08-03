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
    }

    var chooserForRoutine: ExerciseChooserForRoutine?
    var chooserForWorkout: ExerciseToWorkoutChooser?
    private var items = Realm().objects(Exercise).filter("archived == false").sorted("name", ascending: true)
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()

        // used to fit it in one if
        if (chooserForRoutine != nil) || (chooserForWorkout != nil) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelChooser"))
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("doneWithChooser"))
            title = NSLocalizedString("Choose an exercise", comment: "Exercise chooser reached from new workout routine cntroller")
        } else {
            title = NSLocalizedString("Exercises", comment: "Exercise overview")
        }
    }

    func doneWithChooser() -> Void {
        let realm = Realm()
        if let isInRunningWorkout = chooserForWorkout {
            realm.write {
                let performanceMap = PerformanceExerciseMap()
                performanceMap.exercise = self.selectedExercise!
                self.chooserForWorkout?.runningWorkout.performedExercises.append(performanceMap)
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            realm.write{
                self.chooserForRoutine?.workoutRoutine.exercises.append(self.selectedExercise!)
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: self.chooserForRoutine?.completion)
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
    private var prevCell: UITableViewCell?
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
        prevCell?.accessoryType = .None
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        prevCell = cell
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

            let realm = Realm()
            realm.write {
                if itemForCell.builtin {
                    itemForCell.archived = true
                } else {
                    realm.delete(itemForCell)
                }


                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }  
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
