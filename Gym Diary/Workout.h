//
//  Workout.h
//  Gym Diary
//
//  Created by Roman Klauke on 31.12.14.
//  Copyright (c) 2014 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, Pattern, Schedule;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *activites;
@property (nonatomic, retain) NSSet *scheduled;
@property (nonatomic, retain) Pattern *repeat;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addActivitesObject:(Activity *)value;
- (void)removeActivitesObject:(Activity *)value;
- (void)addActivites:(NSSet *)values;
- (void)removeActivites:(NSSet *)values;

- (void)addScheduledObject:(Schedule *)value;
- (void)removeScheduledObject:(Schedule *)value;
- (void)addScheduled:(NSSet *)values;
- (void)removeScheduled:(NSSet *)values;

@end
