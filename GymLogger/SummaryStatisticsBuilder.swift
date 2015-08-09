//
//  SummaryStatisticsBuilder.swift
//  GymLogger
//
//  Created by Roman Klauke on 09.08.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

import Foundation
import RealmSwift

public struct SummaryStatisticsBuilder {
    private var realm: Realm!

    public init(realm: Realm = Realm()) {
        self.realm = realm
    }

    /// If the user starts the app for the first time
    /// it could be necessary to create the summary
    /// record.
    ///
    /// :returns: true if the summary doesn't exist
    public func hasEmptySummary() -> Bool {
        return realm.objects(Summary).count == 0
    }

    /// Creates the initial summary record. There is
    /// only one summary record per installation!
    public func buildInitialSummary() -> Void {
        realm.write {
            let summary = Summary()
        }
    }

    /// Rebuilds the summary statistics based on all
    /// tracked workouts.
    public func rebuildStatisticsSummary() -> Void {
        // Could be a long running operation, so dispatching is required
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            let dispatchRealm = Realm()
            let summary = dispatchRealm.objects(Summary).first!

            // Only perform the rebuild if there are workouts
            if dispatchRealm.objects(Workout).count > 0 {
                let workoutsToIndex = dispatchRealm.objects(Workout).filter("active == false")

                let totalWorkouts = workoutsToIndex.count


                // open the write transaction after each calculation
                dispatchRealm.write {
                    summary.totalWorkouts = totalWorkouts
                }
            }
        })
    }
}
