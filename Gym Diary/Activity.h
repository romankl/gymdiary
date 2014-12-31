//
//  Activity.h
//  Gym Diary
//
//  Created by Roman Klauke on 31.12.14.
//  Copyright (c) 2014 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSSet *inWorkout;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addInWorkoutObject:(Workout *)value;
- (void)removeInWorkoutObject:(Workout *)value;
- (void)addInWorkout:(NSSet *)values;
- (void)removeInWorkout:(NSSet *)values;

@end
