//
//  Workout.h
//  Gym Diary
//
//  Created by Roman Klauke on 03.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActivitySetMap, Pattern, Schedule;

@interface Workout : NSManagedObject

@property(nonatomic, retain) NSNumber *active;
@property(nonatomic, retain) NSDate *createdAt;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *summary;
@property(nonatomic, retain) NSDate *updatedAt;
@property(nonatomic, retain) Pattern *repeat;
@property(nonatomic, retain) NSSet *scheduled;
@property(nonatomic, retain) NSSet *plan;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addScheduledObject:(Schedule *)value;

- (void)removeScheduledObject:(Schedule *)value;

- (void)addScheduled:(NSSet *)values;

- (void)removeScheduled:(NSSet *)values;

- (void)addPlanObject:(ActivitySetMap *)value;

- (void)removePlanObject:(ActivitySetMap *)value;

- (void)addPlan:(NSSet *)values;

- (void)removePlan:(NSSet *)values;

@end
