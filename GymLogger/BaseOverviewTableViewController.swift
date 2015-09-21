//
//  BaseOverviewTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit
import RealmSwift


class BaseOverviewTableViewController: UITableViewController {

    private var notificationToken: NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.tableFooterView?.hidden = true

        navigationItem.leftBarButtonItem = editButtonItem()
        do {
            let realm = try Realm()
            notificationToken = realm.addNotificationBlock { (notification, realm) -> Void in
                // TODO: Replace with better "style"
                self.fetchData()
                self.tableView.reloadData()
            }
        } catch _ as NSError {}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func fetchData() -> Void {
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
}
