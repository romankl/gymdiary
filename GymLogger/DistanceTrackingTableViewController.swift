//
//  DistanceTrackingTableViewController.swift
//  GymLogger
//
//  Created by Roman Klauke on 17.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import UIKit

class DistanceTrackingTableViewController: BaseTrackerTableViewController {

    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        transferValuesFromUiToEntity()
    }

    private func transferValuesFromUiToEntity() -> Void {
        let performance = exerciseToTrack?.detailPerformance(0)
        performance?.distance = (distanceTextField.text! as NSString).doubleValue
        performance?.time = (timeTextField.text! as NSString).doubleValue
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let context = DataCoordinator.sharedInstance.managedObjectContext

        // Manually added exercises have no pre-built setup
        if exerciseToTrack?.performanceCount() == 0 {
            let performance = PerformanceEntity.preparePerformance(1, inContext: context)
            exerciseToTrack?.appendNewPerformance(performance)
        }

        if exerciseToTrack?.detailPerformance(0).time != 0 {
            timeTextField.text = "\(exerciseToTrack!.detailPerformance(0).time!)"
            timeTextField.userInteractionEnabled = isEditingEnabled
        }

        if exerciseToTrack?.detailPerformance(0).distance != 0 {
            distanceTextField.text = "\(exerciseToTrack!.detailPerformance(0).distance!)"
            distanceTextField.userInteractionEnabled = isEditingEnabled
        }

        if !isEditingEnabled {
            createDefaultEditButtons()
        }
    }

    private func createDefaultEditButtons() -> Void {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit,
                target: self,
                action: Selector("editDistance"))
        navigationItem.leftBarButtonItem = nil
    }

    func editDistance() -> Void {
        isEditingEnabled = !isEditingEnabled

        if isEditingEnabled {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel,
                    target: self,
                    action: Selector("editDistance"))
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done,
                    target: self,
                    action: Selector("doneEditing"))
        } else {
            createDefaultEditButtons()
        }

        switchEditingStateOfTextFields()
    }

    func doneEditing() -> Void {
        isEditingEnabled = false
        switchEditingStateOfTextFields()
        transferValuesFromUiToEntity()

        let context = DataCoordinator.sharedInstance.managedObjectContext
        context.trySaveOrRollback()

        createDefaultEditButtons()
    }

    // FIXME: Just a workaround
    private func switchEditingStateOfTextFields() -> Void {
        distanceTextField.userInteractionEnabled = isEditingEnabled
        timeTextField.userInteractionEnabled = isEditingEnabled
    }
}
