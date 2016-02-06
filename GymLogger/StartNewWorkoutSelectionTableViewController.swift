//
//  NewWorkoutSelectionTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 26.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class StartNewWorkout: BaseOverviewTableViewController {
    private var dataSource: StartNewWorkoutDataSource?
    private var workoutDelegate: StartNewWorkoutDelegate?

    private var items = [WorkoutRoutineEntity]()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        fetchData()
    }

    override func fetchData() -> Void {
        let context = DataCoordinator.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: WorkoutRoutineEntity.entityName)
        fetchRequest.sortDescriptors = WorkoutRoutineEntity.sortDescriptorForNewWorkout()
        fetchRequest.predicate = WorkoutRoutineEntity.predicateForRoutines()
        do {
            items = try context.executeFetchRequest(fetchRequest) as! [WorkoutRoutineEntity]

            guard let source = dataSource, let delegate = workoutDelegate else{
                return
            }

            source.items = items
            delegate.items = items

            tableView.reloadData()
        } catch {
            fatalError("failed to fetch err: \(error)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = nil // The super- class provides "Edit" as the left bar button

        fetchData()

        dataSource = StartNewWorkoutDataSource(items: self.items)
        workoutDelegate = StartNewWorkoutDelegate(items: self.items) {
            (cell) -> Void in
            self.performSegueWithIdentifier(SegueIdentifier.StartNewWorkout.rawValue, sender: cell)
        }

        tableView.dataSource = dataSource
        tableView.delegate = workoutDelegate
    }

    @IBAction func datePickerValueChanged(sender: UIDatePicker) {

    }

    private enum SegueIdentifier: String {
        case StartNewWorkout = "startWorkout"
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = SegueIdentifier(rawValue: segue.identifier!)!
        switch identifier {
        case .StartNewWorkout:
            let navController = segue.destinationViewController as! UINavigationController
            let destination = navController.viewControllers.first as! RunningWorkoutTableViewController

            if let routine = workoutDelegate!.selectedRoutine {
                destination.workoutRoutine = routine
            }
            break
        }
    }
}
