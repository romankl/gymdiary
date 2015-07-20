//
//  ExerciseMapWorkout.h
//  Gym Logger
//
//  Created by Roman Klauke on 20.07.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise, Workout;

@interface ExerciseMapWorkout : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) Exercise *forExercise;
@property (nonatomic, retain) Workout *inWorkout;

@end
