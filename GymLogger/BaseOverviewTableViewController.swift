//
//  BaseOverviewTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 23.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit


class BaseOverviewTableViewController: FetchControllerBase {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.tableFooterView?.hidden = true

        navigationItem.leftBarButtonItem = editButtonItem()
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
