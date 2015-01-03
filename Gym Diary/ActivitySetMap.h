//
//  ActivitySetMap.h
//  Gym Diary
//
//  Created by Roman Klauke on 03.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, ActivityScheduleMap, Workout;

@interface ActivitySetMap : NSManagedObject

@property(nonatomic, retain) NSNumber *set;
@property(nonatomic, retain) NSNumber *rep;
@property(nonatomic, retain) NSDecimalNumber *weight;
@property(nonatomic, retain) NSDecimalNumber *distance;
@property(nonatomic, retain) NSDate *time;
@property(nonatomic, retain) NSDate *createdAt;
@property(nonatomic, retain) NSDate *updatedAt;
@property(nonatomic, retain) ActivityScheduleMap *performedInWorkout;
@property(nonatomic, retain) NSSet *withActivity;
@property(nonatomic, retain) Workout *shouldPerform;
@end

@interface ActivitySetMap (CoreDataGeneratedAccessors)

- (void)addWithActivityObject:(Activity *)value;

- (void)removeWithActivityObject:(Activity *)value;

- (void)addWithActivity:(NSSet *)values;

- (void)removeWithActivity:(NSSet *)values;

@end
