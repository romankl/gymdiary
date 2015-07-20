//
//  WorkoutRoutine.h
//  Gym Logger
//
//  Created by Roman Klauke on 20.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorkoutRoutineMapExercise;

@interface WorkoutRoutine : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * planed;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * used;
@property (nonatomic, retain) NSSet *usesExercise;
@end

@interface WorkoutRoutine (CoreDataGeneratedAccessors)

- (void)addUsesExerciseObject:(WorkoutRoutineMapExercise *)value;
- (void)removeUsesExerciseObject:(WorkoutRoutineMapExercise *)value;
- (void)addUsesExercise:(NSSet *)values;
- (void)removeUsesExercise:(NSSet *)values;

@end
