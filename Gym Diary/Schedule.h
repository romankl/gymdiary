//
//  Schedule.h
//  Gym Diary
//
//  Created by Roman Klauke on 01.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActivityScheduleMap, Workout;

@interface Schedule : NSManagedObject

@property(nonatomic, retain) NSNumber *active;
@property(nonatomic, retain) NSDate *createdAt;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, retain) NSString *note;
@property(nonatomic, retain) NSNumber *progress;
@property(nonatomic, retain) NSDate *updatedAt;
@property(nonatomic, retain) NSDate *estimatedEnd;
@property(nonatomic, retain) NSNumber *reminder;
@property(nonatomic, retain) NSNumber *remindMinBefore;
@property(nonatomic, retain) Workout *useWorkout;
@property(nonatomic, retain) NSSet *usedActivity;
@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)addUsedActivityObject:(ActivityScheduleMap *)value;

- (void)removeUsedActivityObject:(ActivityScheduleMap *)value;

- (void)addUsedActivity:(NSSet *)values;

- (void)removeUsedActivity:(NSSet *)values;

@end
