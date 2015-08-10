//
//  WorkoutHistoryTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 01.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift

class WorkoutHistoryTableViewController: BaseOverviewTableViewController {
    private struct Constants {
        static let cellIdentifier = "historyCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private var items = Realm().objects(Workout).sorted("startedAt", ascending: false)
    override func fetchData() {
        items = Realm().objects(Workout).sorted("startedAt", ascending: false)
        tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        // TODO: Replace with something more ...
        cell.textLabel?.text = items[indexPath.row].name

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let realm = Realm()
            realm.write {
                let item = self.items[indexPath.row]
                realm.delete(item)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
}