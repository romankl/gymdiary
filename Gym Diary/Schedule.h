//
//  Schedule.h
//  Gym Diary
//
//  Created by Roman Klauke on 04.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Schedule : NSManagedObject

@property(nonatomic, retain) NSNumber *active;
@property(nonatomic, retain) NSDate *createdAt;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, retain) NSDate *estimatedEnd;
@property(nonatomic, retain) NSString *note;
@property(nonatomic, retain) NSNumber *progress;
@property(nonatomic, retain) NSNumber *reminder;
@property(nonatomic, retain) NSNumber *remindMinBefore;
@property(nonatomic, retain) NSDate *updatedAt;
@property(nonatomic, retain) Workout *useWorkout;

@end
