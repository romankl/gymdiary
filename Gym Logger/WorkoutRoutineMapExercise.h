//
//  WorkoutRoutineMapExercise.h
//  Gym Logger
//
//  Created by Roman Klauke on 20.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise, WorkoutRoutine;

@interface WorkoutRoutineMapExercise : NSManagedObject

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) WorkoutRoutine *forWorkout;
@property (nonatomic, retain) Exercise *withExercise;

@end
