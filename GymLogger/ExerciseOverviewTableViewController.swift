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

    var chooser: ExerciseChooser?
    private var items = Realm().objects(Exercise).sorted("name", ascending: true)
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()

        if let isPicker = chooser {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelChooser"))
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("doneWithChooser"))
        }
    }

    func doneWithChooser() -> Void {
        let realm = Realm()
        realm.write{
            self.chooser?.workoutRoutine.exercises.append(self.selectedExercise!)
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: self.chooser?.completion)
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
        if let inPicker = chooser {
            selectedExercise = items[indexPath.row]
            prevCell?.accessoryType = .None
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = .Checkmark
            prevCell = cell
            cell?.selected = false
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let itemForCell = items[indexPath.row]
        cell.textLabel?.text = itemForCell.name
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source

            let itemForCell = items[indexPath.row]

            let realm = Realm()
            realm.write {
                realm.delete(itemForCell)
                self.fetchData()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
