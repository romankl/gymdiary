//
// Created by Roman Klauke on 20.02.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//

import Foundation
import UIKit

class ExerciseOverviewHeaderFilterTableView: UIView, UITableViewDelegate, UITableViewDataSource {

    private static let cellIdentifier = "cell"

    private var tableView: UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)

        defaultInit(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        defaultInit(self.frame)
    }

    private func defaultInit(frame: CGRect) {
        self.tableView = UITableView(frame: frame, style: .Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self


        self.tableView.addConstraint(NSLayoutConstraint(item: self.tableView,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: self.superview,
            attribute: .Leading, 
            multiplier: 1,
            constant: 0))

        self.tableView.addConstraint(NSLayoutConstraint(item: self.tableView,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: self.superview,
            attribute: .Trailing,
            multiplier: 1,
            constant: 0))

        self.tableView.addConstraint(NSLayoutConstraint(item: self.tableView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self.superview,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0))

        self.tableView.addConstraint(NSLayoutConstraint(item: self.tableView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self.superview,
            attribute: .Top,
            multiplier: 1,
            constant: 0))


        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ExerciseOverviewHeaderFilterTableView.cellIdentifier)
        self.tableView.reloadData()
        print("#### Hier: \(__LINE__)")
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("#### Hier: \(__LINE__)")
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("#### Hier: \(__LINE__)")
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("#### Hier: \(__LINE__)")
        return 6
    }

    func tableView(_ tableView: UITableView!, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return UITableViewAutomaticDimension
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ExerciseOverviewHeaderFilterTableView.cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = "test"

        print("#### Hier: \(__LINE__)")

        return cell
    }

}
