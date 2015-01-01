//
//  ActivityScheduleMap.h
//  Gym Diary
//
//  Created by Roman Klauke on 01.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, Schedule;

@interface ActivityScheduleMap : NSManagedObject

@property(nonatomic, retain) NSDecimalNumber *distance;
@property(nonatomic, retain) NSDate *time;
@property(nonatomic, retain) NSDecimalNumber *sets;
@property(nonatomic, retain) NSNumber *reps;
@property(nonatomic, retain) NSDate *startTime;
@property(nonatomic, retain) NSDate *endTime;
@property(nonatomic, retain) NSDate *createAt;
@property(nonatomic, retain) NSDate *updatedAt;
@property(nonatomic, retain) Activity *usedActivity;
@property(nonatomic, retain) Schedule *inSchedule;

@end
