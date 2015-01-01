//
//  Activity.h
//  Gym Diary
//
//  Created by Roman Klauke on 01.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActivityScheduleMap, Workout;

@interface Activity : NSManagedObject

@property(nonatomic, retain) NSNumber *active;
@property(nonatomic, retain) NSDate *createdAt;
@property(nonatomic, retain) NSString *imagePath;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *summary;
@property(nonatomic, retain) NSDate *updatedAt;
@property(nonatomic, retain) NSSet *inWorkout;
@property(nonatomic, retain) ActivityScheduleMap *inScheduleMap;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addInWorkoutObject:(Workout *)value;

- (void)removeInWorkoutObject:(Workout *)value;

- (void)addInWorkout:(NSSet *)values;

- (void)removeInWorkout:(NSSet *)values;

@end
