//
//  Exercise.h
//  Gym Logger
//
//  Created by Roman Klauke on 20.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExerciseMapWorkout, WorkoutRoutineMapExercise;

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * used;
@property (nonatomic, retain) NSNumber * bodyGroup;
@property (nonatomic, retain) NSNumber * builtin;
@property (nonatomic, retain) NSDate * lastUsed;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *performed;
@property (nonatomic, retain) NSSet *templateInRoutine;
@end

@interface Exercise (CoreDataGeneratedAccessors)

- (void)addPerformedObject:(ExerciseMapWorkout *)value;
- (void)removePerformedObject:(ExerciseMapWorkout *)value;
- (void)addPerformed:(NSSet *)values;
- (void)removePerformed:(NSSet *)values;

- (void)addTemplateInRoutineObject:(WorkoutRoutineMapExercise *)value;
- (void)removeTemplateInRoutineObject:(WorkoutRoutineMapExercise *)value;
- (void)addTemplateInRoutine:(NSSet *)values;
- (void)removeTemplateInRoutine:(NSSet *)values;

@end
