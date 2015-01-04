//
//  ActivityWorkoutMap.h
//  Gym Diary
//
//  Created by Roman Klauke on 04.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, ActivitySetMap, Workout;

@interface ActivityWorkoutMap : NSManagedObject

@property(nonatomic, retain) Activity *usesActitivity;
@property(nonatomic, retain) Workout *inWorkout;
@property(nonatomic, retain) NSSet *withSets;
@end

@interface ActivityWorkoutMap (CoreDataGeneratedAccessors)

- (void)addWithSetsObject:(ActivitySetMap *)value;

- (void)removeWithSetsObject:(ActivitySetMap *)value;

- (void)addWithSets:(NSSet *)values;

- (void)removeWithSets:(NSSet *)values;

@end
