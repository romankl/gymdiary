//
//  ActivityScheduleMap.h
//  Gym Diary
//
//  Created by Roman Klauke on 03.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, Schedule;

@interface ActivityScheduleMap : NSManagedObject

@property(nonatomic, retain) NSDate *createAt;
@property(nonatomic, retain) NSDecimalNumber *distance;
@property(nonatomic, retain) NSDate *endTime;
@property(nonatomic, retain) NSDate *startTime;
@property(nonatomic, retain) NSDate *time;
@property(nonatomic, retain) NSDate *updatedAt;
@property(nonatomic, retain) Schedule *inSchedule;
@property(nonatomic, retain) Activity *usedActivity;
@property(nonatomic, retain) NSSet *performed;
@end

@interface ActivityScheduleMap (CoreDataGeneratedAccessors)

- (void)addPerformedObject:(NSManagedObject *)value;

- (void)removePerformedObject:(NSManagedObject *)value;

- (void)addPerformed:(NSSet *)values;

- (void)removePerformed:(NSSet *)values;

@end
