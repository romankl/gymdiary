//
//  Workout.h
//  Gym Logger
//
//  Created by Roman Klauke on 20.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExerciseMapWorkout;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSDate * startedAt;
@property (nonatomic, retain) NSDate * endedAt;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSSet *performedExercise;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addPerformedExerciseObject:(ExerciseMapWorkout *)value;
- (void)removePerformedExerciseObject:(ExerciseMapWorkout *)value;
- (void)addPerformedExercise:(NSSet *)values;
- (void)removePerformedExercise:(NSSet *)values;

@end
