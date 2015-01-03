//
//  Pattern.h
//  Gym Diary
//
//  Created by Roman Klauke on 03.01.15.
//  Copyright (c) 2015 Roman Klauke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Pattern : NSManagedObject

@property(nonatomic, retain) NSNumber *active;
@property(nonatomic, retain) NSNumber *createdAt;
@property(nonatomic, retain) NSNumber *fr;
@property(nonatomic, retain) NSNumber *mo;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSNumber *regularWeek;
@property(nonatomic, retain) NSNumber *sa;
@property(nonatomic, retain) NSNumber *su;
@property(nonatomic, retain) NSString *summary;
@property(nonatomic, retain) NSNumber *th;
@property(nonatomic, retain) NSNumber *tu;
@property(nonatomic, retain) NSDate *updatedAt;
@property(nonatomic, retain) NSNumber *we;
@property(nonatomic, retain) NSSet *workout;
@end

@interface Pattern (CoreDataGeneratedAccessors)

- (void)addWorkoutObject:(Workout *)value;

- (void)removeWorkoutObject:(Workout *)value;

- (void)addWorkout:(NSSet *)values;

- (void)removeWorkout:(NSSet *)values;

@end
