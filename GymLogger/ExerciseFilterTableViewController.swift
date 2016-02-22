//
// Created by Roman Klauke on 21.02.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//


import Foundation
import UIKit

class ExerciseFilterTableViewController: BaseOverviewTableViewController {

    private let bodyParts = BodyParts.allBodyParts()
    private let equipment = ExerciseType.allTypes()

    private struct Constants {
        static let segueIdentifier = "filterExercise"
        static let defaultFilterCellIdentifier = "cell"
        static let foundExerciseCellIdentifier = "searchCell"
    }

    var chooserForRoutine: ExerciseChooserForRoutine?
    var chooserForWorkout: ExerciseToWorkoutChooser?

    let searchController = UISearchController(searchResultsController: nil)
    var foundExercises = [ExerciseEntity]()
    override func viewDidLoad() {
        super.viewDidLoad()


        if let _ = chooserForWorkout {
            prepareCancelButton()
        }

        if let _ = chooserForRoutine {
            prepareCancelButton()
        }

        definesPresentationContext = true

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        self.tableView.tableHeaderView = searchController.searchBar
    }

    private func prepareCancelButton() -> Void {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancel"))
        navigationItem.leftBarButtonItem = cancelButton
    }

    func cancel() -> Void {
        presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }

    func searchExerises(searchText: String, scope: String = "All") -> Void {
        let context = DataCoordinator.sharedInstance.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: ExerciseEntity.entityName)
        fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", ExerciseEntity.Keys.name.rawValue,
                searchText)
        fetchRequest.sortDescriptors = ExerciseEntity.sortDescriptorsForOverview()

        do {
            let result = try context.executeFetchRequest(fetchRequest)
            foundExercises = result as! [ExerciseEntity]
            tableView.reloadData()
        } catch {
        }
    }

    @available(iOS 5.0, *) override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let cell = sender as? UITableViewCell else {
            return
        }

        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }

        guard let filterSection = ExerciseFilterSection(rawValue: indexPath.section) else {
            return
        }


        var predicate: NSPredicate
        switch filterSection {
        case .BodyPart:
            let item = bodyParts[indexPath.row]
            predicate = NSPredicate(format: "%K == %i", ExerciseEntity.Keys.bodyGroup.rawValue, item
            .rawValue)
            break
        case .Equipment:
            let item = equipment[indexPath.row]
            predicate = NSPredicate(format: "%K == %i", ExerciseEntity.Keys.type.rawValue, item.rawValue)
            break
        default:
            predicate = NSPredicate(format: "1 == 1") // TODO: figure out, how to query all rows in thisscenario
            break
        }

        let destination = segue.destinationViewController as! ExerciseOverviewTableViewController
        destination.exerciseFilterPredicate = predicate
        destination.chooserForRoutine = chooserForRoutine
        destination.chooserForWorkout = chooserForWorkout
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, titleForHeaderInSection section:
            Int) ->
            String? {
        guard let filterSection = ExerciseFilterSection(rawValue: section) else {
            return ""
        }
        return filterSection.description()
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return foundExercises.count
        }


        guard let filterSection = ExerciseFilterSection(rawValue: section) else {
            return 0
        }

        switch filterSection {
        case .All: return 1
        case .BodyPart: return bodyParts.count
        case .Equipment: return equipment.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
            UITableViewCell {
        if searchController.active && searchController.searchBar.text != "" {
            let exercise = foundExercises[indexPath.row]

            guard let cell = tableView.dequeueReusableCellWithIdentifier(ExerciseFilterTableViewController.Constants.foundExerciseCellIdentifier)
            else {
                return UITableViewCell()
            }

            cell.textLabel?.text = exercise.name
            return cell
        }


        guard let filterSection = ExerciseFilterSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCellWithIdentifier(ExerciseFilterTableViewController.Constants
        .defaultFilterCellIdentifier, forIndexPath: indexPath)

        switch filterSection {
        case .BodyPart:
            cell.textLabel?.text = "\(bodyParts[indexPath.row])"
            break
        case .Equipment:
            cell.textLabel?.text = "\(equipment[indexPath.row])"
            break
        case .All:
            cell.textLabel?.text = NSLocalizedString("All Exercises", comment: "all")
            break
        }

        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return 1
        }

        return ExerciseFilterSection.numberOfSections()
    }
}


extension ExerciseFilterTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchExerises(searchController.searchBar.text!)
    }
}
